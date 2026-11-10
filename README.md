# 出雲カフェ Vlog マップ — Rails API

Base44 アプリ（出雲カフェ Vlog マップ）のバックエンドとして動く Rails 7.1（API モード）です。
Base44 側の `railsApi` バックエンド関数がこの API を呼び出します。

- 認証：メールアドレス + パスワード（bcrypt）、ログイン時に API トークンを発行
- 認証が必要な API：`Authorization: Bearer <token>` を付けて呼び出します
- 画像：Base64 文字列をそのまま TEXT カラムに保存（Active Storage は使いません）

## 1. テーブル構成

| テーブル | 主なカラム |
| --- | --- |
| users | username, mail, password_digest, profile_image, api_token |
| cafes | name, address, latitude, longitude, tell_number, parking, credit_card, cashless, image |
| posts | user_id, cafe_id, visit_date, content, image, visibility |
| tags | name |
| post_tags | post_id, tag_id |
| want_cafes | user_id, cafe_id |
| likes | user_id, post_id |

## 2. ローカルで起動する

```bash
bundle install
bundle exec rails db:prepare   # DB 作成 + マイグレーション
bundle exec rails db:seed      # カフェ5件とタグの初期データ
bundle exec rails server -p 3000
curl http://localhost:3000/    # => {"status":"ok", ...}
```

## 3. Render で動かす

### 方法A：Blueprint（おすすめ）

リポジトリ直下に `render.yaml` を置いたので、Render の **New > Blueprint** から接続すると
Web サービスと PostgreSQL がまとめて作成されます（`SECRET_KEY_BASE` も自動生成）。

### 方法B：手動で設定

1. **New > PostgreSQL** を作成し、Internal Database URL を控える
2. **New > Web Service** で GitHub リポジトリを接続（Runtime: Ruby）
3. Build Command

   ```
   bundle install && bundle exec rails db:prepare && bundle exec rails db:seed
   ```

   （`db:migrate` でも可。`db:seed` は重複登録されないので毎回実行して大丈夫です）

4. Start Command

   ```
   bundle exec puma -C config/puma.rb
   ```

5. Environment に以下を設定

   | キー | 値 |
   | --- | --- |
   | `RAILS_ENV` | `production` |
   | `SECRET_KEY_BASE` | `openssl rand -hex 64` の出力（必須） |
   | `DATABASE_URL` | 手順1の PostgreSQL の URL |
   | `RAILS_MAX_THREADS` | `5` |

6. カフェ5件が地図に出ない場合は、Render の Shell で初期データを投入

   ```bash
   bundle exec rails db:seed
   ```

`DATABASE_URL` を設定しない場合は SQLite で起動しますが、Render の無料プランは
ディスクが永続化されないため、再デプロイでデータが消えます。PostgreSQL を推奨します。

## 4. エンドポイント

すべて `/api` 配下です。レスポンスは JSON です。

| メソッド | パス | 認証 | 説明 |
| --- | --- | --- | --- |
| GET | `/` , `/up` | — | 死活確認 `{"status":"ok"}` |
| POST | `/api/session` | — | ログイン |
| POST | `/api/users` | — | 新規登録 |
| GET | `/api/me` | 必要 | ログイン中ユーザー |
| PATCH | `/api/users/:id` | 必要 | プロフィール更新（本人のみ） |
| GET | `/api/cafes` | — | カフェ一覧 |
| GET | `/api/cafes/:id` | — | カフェ詳細 |
| GET | `/api/posts?cafe_id=&tag_id=` | — | 投稿一覧（非公開は本人のみ） |
| POST | `/api/posts` | 必要 | 投稿作成 |
| GET | `/api/tags` | — | タグ一覧 |
| GET | `/api/want_cafes` | 必要 | 行きたいカフェ一覧 |
| POST | `/api/want_cafes` | 必要 | 行きたいカフェ追加 |
| DELETE | `/api/want_cafes/:id` | 必要 | 行きたいカフェ解除 |
| POST | `/api/likes` | 必要 | いいね |
| DELETE | `/api/likes/:id` | 必要 | いいね解除 |

### リクエスト / レスポンス例

**ログイン**

```json
// POST /api/session
{ "mail": "yuna@example.com", "password": "password1234" }

// 200
{ "token": "9f3c…", "user": { "id": 1, "username": "yuna", "mail": "yuna@example.com", "profile_image": null } }
```

**新規登録**

```json
// POST /api/users
{ "user": { "username": "yuna", "mail": "yuna@example.com", "password": "password1234", "profile_image": null } }

// 201
{ "user": { "id": 1, "username": "yuna", "mail": "yuna@example.com", "profile_image": null } }

// 422（バリデーションエラー）
{ "error": "validation_failed", "errors": ["メールアドレスはすでに存在します"] }
```

**カフェ一覧**

```json
// GET /api/cafes
{
  "cafes": [
    {
      "id": 1,
      "name": "Cafe Naka蔵",
      "address": "島根県出雲市今市町中町689",
      "latitude": 35.3642246,
      "longitude": 132.7566666,
      "tell_number": "0853-31-5880",
      "parking": true,
      "credit_card": null,
      "cashless": null,
      "image": null,
      "tags": [{ "id": 1, "name": "抹茶" }]
    }
  ]
}
```

**投稿作成**

```json
// POST /api/posts   Authorization: Bearer <token>
{
  "post": {
    "cafe_id": 1,
    "visit_date": "2026-11-05",
    "content": "抹茶スイーツがとても美味しかったです！",
    "image": "<Base64 文字列>",
    "visibility": true,
    "tag_ids": [1, 2]
  }
}

// 201
{
  "post": {
    "id": 10,
    "cafe_id": 1,
    "cafe_name": "Cafe Naka蔵",
    "user": { "id": 1, "username": "yuna", "profile_image": null },
    "visit_date": "2026-11-05",
    "content": "抹茶スイーツがとても美味しかったです！",
    "image": "<Base64 文字列>",
    "visibility": true,
    "tags": [{ "id": 1, "name": "抹茶" }],
    "likes_count": 0,
    "liked": false,
    "like_id": null
  }
}
```

**行きたい / いいね**

```json
// POST /api/want_cafes   { "want_cafe": { "cafe_id": 3 } }  => 201 { "want_cafe": { "id": 5, "cafe_id": 3, "user_id": 1 } }
// DELETE /api/want_cafes/5                                => 204
// POST /api/likes        { "like": { "post_id": 10 } }     => 201 { "like": { "id": 7, "post_id": 10, "user_id": 1 } }
// DELETE /api/likes/7                                     => 204
```

## 5. Base44 側の設定

Base44 の Secrets に登録する値は次の 1 つだけです。

- `RAILS_API_BASE_URL` … Render の URL（例 `https://my-rails-api-g30f.onrender.com`）

ルートの対応は `base44/functions/railsApi/entry.ts` の `ROUTES` に定義済みで、
このリポジトリのパスと一致させています。URL の変更（ドメイン変更・別サービスへの移行）は
Secret の書き換えだけで済みます。

## 6. 注意点

- 投稿画像・プロフィール画像は Base64 をそのまま保存するため、1 枚あたり数 MB になります。
  本番運用で容量が気になる場合は Active Storage + S3 などへの移行を検討してください。
- パスワードは 8 文字以上（アプリの登録画面と同じ条件）。
- 非公開投稿は作成者本人にだけ返します。
- トークンはログインごとに再発行されます（再ログインすると以前のトークンは無効になります）。
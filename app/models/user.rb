class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :want_cafes, dependent: :destroy
  has_many :likes, dependent: :destroy

  before_validation :normalize_mail

  validates :username, presence: true, length: { maximum: 20 }
  validates :mail,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  # ログイン時に発行する簡易 API トークン（Authorization: Bearer で送られます）
  def regenerate_api_token!
    update_columns(api_token: SecureRandom.hex(32), updated_at: Time.current)
    api_token
  end

  def as_api_json
    { id: id, username: username, mail: mail, profile_image: profile_image }
  end

  private

  def normalize_mail
    self.mail = mail.to_s.strip.downcase
  end
end
class Cafe < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :want_cafes, dependent: :destroy

  validates :name, presence: true

  # カフェに紐づく投稿のタグを重複なくまとめます。
  def tags_summary
    posts.includes(post_tags: :tag).flat_map(&:tags).uniq(&:id).map { |tag| { id: tag.id, name: tag.name } }
  end

  def as_api_json
    {
      id: id,
      name: name,
      address: address,
      latitude: latitude&.to_f,
      longitude: longitude&.to_f,
      tell_number: tell_number,
      parking: parking,
      credit_card: credit_card,
      cashless: cashless,
      image: image,
      tags: tags_summary
    }
  end
end
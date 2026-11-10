class Post < ApplicationRecord
  belongs_to :user
  belongs_to :cafe

  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :likes, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }

  def as_api_json(viewer = nil)
    like = viewer ? likes.find { |record| record.user_id == viewer.id } : nil

    {
      id: id,
      cafe_id: cafe_id,
      cafe_name: cafe&.name,
      user: user && {
        id: user.id,
        username: user.username,
        profile_image: user.profile_image
      },
      visit_date: visit_date&.strftime("%Y-%m-%d"),
      content: content,
      image: image,
      visibility: visibility,
      tags: tags.map { |tag| { id: tag.id, name: tag.name } },
      likes_count: likes.size,
      liked: like.present?,
      like_id: like&.id
    }
  end
end
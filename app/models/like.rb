class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :post_id, uniqueness: { scope: :user_id }

  def as_api_json
    { id: id, post_id: post_id, user_id: user_id }
  end
end
class WantCafe < ApplicationRecord
  belongs_to :user
  belongs_to :cafe

  validates :cafe_id, uniqueness: { scope: :user_id }

  def as_api_json
    { id: id, cafe_id: cafe_id, user_id: user_id, created_at: created_at&.iso8601 }
  end
end
class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  validates :title, presence: true
  validates :content, presence: true

  def liked_by?(user_id)
    likes.exists?(user_id: user_id)
  end

end

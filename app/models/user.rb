class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :following_users, through: :relationships, source: :followed
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy
  has_many :follower_users, through: :reverse_of_relationships, source: :follower
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: /@.*\./}

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    follower_users.include?(user)
  end

end
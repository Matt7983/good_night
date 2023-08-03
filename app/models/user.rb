class User < ApplicationRecord
  has_many :followers, class_name: "Follower", foreign_key: "followee_id", primary_key: "id", dependent: :destroy

  def follower_ids
    followers.pluck(:follower_id)
  end

  def followed_users
    User.where(id: follower_ids)
  end
end

class User < ApplicationRecord
  has_many :followers, class_name: "Follower", foreign_key: "followee_id", primary_key: "id", dependent: :destroy

  FollowerAlreadyExistsError = Class.new(StandardError)
  FollowerNotExistsError = Class.new(StandardError)

  def follower_ids
    followers.pluck(:follower_id)
  end

  def followed_users
    User.where(id: follower_ids)
  end

  def add_follower(follower_id)
    raise FollowerAlreadyExistsError if follower_ids.include?(follower_id)

    Follower.create(followee_id: id, follower_id: follower_id)
  end

  def remove_follower(follower_id)
    raise FollowerNotExistsError unless follower_ids.include?(follower_id)

    Follower.find_by(followee_id: id, follower_id: follower_id).destroy
  end
end

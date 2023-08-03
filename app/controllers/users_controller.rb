class UsersController < ApplicationController
  before_action :check_follower_exists, only: [:follow]

  FollowerNotFoundError = Class.new(StandardError)

  def follow
    ActiveRecord::Base.transaction do
      user = User.lock.find(params[:id])
      user.add_follower(params[:follower_id].to_i)

      render json: { followed_users: user.followed_users }
    end
  rescue User::FollowerAlreadyExistsError
    render json: { error_code: 'FOLLOWER_ALREADY_EXISTS' }, status: 409
  end

  def unfollow
    ActiveRecord::Base.transaction do
      user = User.lock.find(params[:id])
      user.remove_follower(params[:follower_id].to_i)

      render json: { followed_users: user.followed_users }
    end
  rescue User::FollowerNotExistsError
    render json: { error_code: 'USER_NOT_FOLLOWED' }, status: 404
  end

  private

  def check_follower_exists
    follower = User.find_by_id(params[:follower_id])
    return if follower

    render json: { error_code: 'FOLLOWER_NOT_FOUND' }, status: 404
  end
end

class ClocksController < ApplicationController
  before_action :check_active_clock_exists, only: :create
  before_action :check_last_clock_not_clock_out, only: :update

  def create
    ActiveRecord::Base.transaction do
      user = User.lock.find(params[:user_id])
      user.clocks.create(clock_in: Time.zone.now)

      render json: { clocks: user.clocks.order(clock_in: :desc) }
    end
  end

  def update
    ActiveRecord::Base.transaction do
      user = User.lock.find(params[:user_id])
      latest_clock = user.clocks.last
      latest_clock.update(clock_out: Time.zone.now, duration: Time.zone.now - latest_clock.clock_in)

      render json: { clocks: user.clocks.order(clock_in: :desc) }
    end
  end

  private

  def check_active_clock_exists
    user = User.find(params[:user_id])
    return if user.clocks.where(clock_out: nil).empty?

    render json: { error_code: 'ACTIVE_CLOCK_EXISTS' }, status: 400
  end

  def check_last_clock_not_clock_out
    user = User.find(params[:user_id])
    return if user.clocks.exists? && user.clocks.last.clock_out.nil?

    render json: { error_code: 'NO_ACTIVE_CLOCK' }, status: 404
  end
end

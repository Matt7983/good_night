require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#follower_ids' do
    let!(:followee) { FactoryBot.create(:user) }
    let!(:followers) { FactoryBot.create_list(:user, 3) }

    before do
      followers.each do |follower|
        Follower.create(followee_id: followee.id, follower_id: follower.id)
      end
    end

    it 'returns the ids of the followers' do
      expect(followee.follower_ids).to match_array(followers.map(&:id))
    end
  end

  describe '#followed_users' do
    let!(:followee) { FactoryBot.create(:user) }
    let!(:followers) { FactoryBot.create_list(:user, 3) }

    before do
      followers.each do |follower|
        Follower.create(followee_id: followee.id, follower_id: follower.id)
      end
    end

    it 'returns the users who follow the user' do
      expect(followee.followed_users).to match_array(followers)
    end
  end
end

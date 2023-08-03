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

  describe '#add_follower' do
    let!(:followee) { FactoryBot.create(:user) }
    let!(:user) { FactoryBot.create(:user) }

    it 'adds a follower' do
      followee.add_follower(user.id)
      expect(followee.follower_ids).to include(user.id)
    end

    context 'when the follower already exists' do
      before { Follower.create(followee_id: followee.id, follower_id: user.id) }

      it 'raises an error' do
        expect { followee.add_follower(user.id) }.to raise_error(User::FollowerAlreadyExistsError)
      end
    end
  end


  describe '#remove_follower' do
    let!(:followee) { FactoryBot.create(:user) }
    let!(:follower) { FactoryBot.create(:user) }

    before { Follower.create(followee_id: followee.id, follower_id: follower.id) }

    it 'removes the follower' do
      followee.remove_follower(follower.id)
      expect(followee.follower_ids).to_not include(follower.id)
    end

    context 'when the follower not exists' do
      let!(:not_followed_user) { FactoryBot.create(:user) }

      it 'raises an error' do
        expect { followee.remove_follower(not_followed_user.id) }.to raise_error(User::FollowerNotExistsError)
      end
    end
  end
end

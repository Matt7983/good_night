require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /follow" do
    let(:user) { FactoryBot.create(:user)}
    let(:follower) { FactoryBot.create(:user)}

    context 'when everything is ok' do
      before do
        post "/users/#{user.id}/follow", params: { follower_id: follower.id }
      end

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the followed users' do
        expect(response.body).to eq({ followed_users: [follower] }.to_json)
      end
    end

    context 'when follower does not exist' do
      before do
        post "/users/#{user.id}/follow", params: { follower_id: 0 }
      end

      it 'returns a 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns FOLLOWER_NOT_FOUND error code' do
        expect(response.body).to eq({ error_code: 'FOLLOWER_NOT_FOUND' }.to_json)
      end
    end

    context 'when user already followed' do
      before do
        Follower.create(followee_id: user.id, follower_id: follower.id)
        allow(user).to receive(:add_follower).and_raise(User::FollowerAlreadyExistsError)
        post "/users/#{user.id}/follow", params: { follower_id: follower.id }
      end

      it 'returns a 409' do
        expect(response).to have_http_status(409)
      end

      it 'returns FOLLOWER_ALREADY_EXISTS error code' do
        expect(response.body).to eq({ error_code: 'FOLLOWER_ALREADY_EXISTS' }.to_json)
      end
    end
  end

  describe "POST /unfollow" do
    let(:user) { FactoryBot.create(:user)}
    let(:follower) { FactoryBot.create(:user)}

    context 'when everything is ok' do
      before do
        Follower.create(followee_id: user.id, follower_id: follower.id)
        post "/users/#{user.id}/unfollow", params: { follower_id: follower.id }
      end

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the followed users' do
        expect(response.body).to eq({ followed_users: [] }.to_json)
      end
    end

    context 'when everything is ok' do
      before do
        Follower.create(followee_id: user.id, follower_id: follower.id)
        post "/users/#{user.id}/unfollow", params: { follower_id: follower.id }
      end

      it 'returns a 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns empty followed users' do
        expect(response.body).to eq({ followed_users: [] }.to_json)
      end
    end

    context 'when user not followed the follower' do
      before do
        allow(user).to receive(:remove_follower).and_raise(User::FollowerNotExistsError)
        post "/users/#{user.id}/unfollow", params: { follower_id: follower.id }
      end

      it 'returns a 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns USER_NOT_FOLLOWED error code' do
        expect(response.body).to eq({ error_code: 'USER_NOT_FOLLOWED' }.to_json)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /follow' do
    let(:user) { FactoryBot.create(:user) }
    let(:follower) { FactoryBot.create(:user) }

    context 'when everything is ok' do
      before do
        post "/users/#{user.id}/follow", params: { follower_id: follower.id }
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
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
        expect(response).to have_http_status(:not_found)
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
        expect(response).to have_http_status(:conflict)
      end

      it 'returns FOLLOWER_ALREADY_EXISTS error code' do
        expect(response.body).to eq({ error_code: 'FOLLOWER_ALREADY_EXISTS' }.to_json)
      end
    end
  end

  describe 'POST /unfollow' do
    let(:user) { FactoryBot.create(:user) }
    let(:follower) { FactoryBot.create(:user) }

    context 'when everything is ok' do
      before do
        Follower.create(followee_id: user.id, follower_id: follower.id)
        post "/users/#{user.id}/unfollow", params: { follower_id: follower.id }
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the followed users' do
        expect(response.body).to eq({ followed_users: [] }.to_json)
      end
    end

    context 'when user not followed the follower' do
      before do
        allow(user).to receive(:remove_follower).and_raise(User::FollowerNotExistsError)
        post "/users/#{user.id}/unfollow", params: { follower_id: follower.id }
      end

      it 'returns a 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns USER_NOT_FOLLOWED error code' do
        expect(response.body).to eq({ error_code: 'USER_NOT_FOLLOWED' }.to_json)
      end
    end
  end

  describe 'GET /followers_records' do
    let(:user) { FactoryBot.create(:user) }
    let(:follower) { FactoryBot.create(:user) }

    context 'when user does not follow any followers' do
      before do
        FactoryBot.create(:clock, user: follower)
        get "/users/#{user.id}/followers_records"
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns empty array' do
        expect(response.body).to eq({ followers_records: [] }.to_json)
      end
    end

    context 'when followers have no clocks' do
      before do
        Follower.create(followee_id: user.id, follower_id: follower.id)
        get "/users/#{user.id}/followers_records"
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns empty array' do
        expect(response.body).to eq({ followers_records: [] }.to_json)
      end
    end

    context 'when followers have a clock before 7 days' do
      before do
        Follower.create(followee_id: user.id, follower_id: follower.id)
        FactoryBot.create(:clock, user: follower, clock_in: 8.days.ago)
        get "/users/#{user.id}/followers_records"
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns empty array' do
        expect(response.body).to eq({ followers_records: [] }.to_json)
      end
    end

    context 'when followers have several clocks with different durations' do
      let!(:follower2) { FactoryBot.create(:user) }
      let!(:clocks) do
        [
          FactoryBot.create(:clock, user: follower, clock_in: 6.days.ago, clock_out: 4.days.ago),
          FactoryBot.create(:clock, user: follower2, clock_in: 4.days.ago, clock_out: 3.days.ago),
          FactoryBot.create(:clock, user: follower, clock_in: 10.hours.ago, clock_out: 9.hours.ago)
        ]
      end

      before do
        FactoryBot.create(:clock, user: follower2, clock_in: 10.days.ago, clock_out: 8.days.ago)
        Follower.create(followee_id: user.id, follower_id: follower.id)
        Follower.create(followee_id: user.id, follower_id: follower2.id)
        get "/users/#{user.id}/followers_records"
      end

      it 'returns a 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns with all clocks duration ordered' do
        expect(response.body).to eq({ followers_records: ClockPrinter.render_as_json(clocks) }.to_json)
      end
    end
  end
end

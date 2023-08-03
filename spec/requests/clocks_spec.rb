require 'rails_helper'

RSpec.describe 'Clocks', type: :request do
  describe 'POST /create' do
    subject(:do_create) do
      post "/users/#{user.id}/clock_in"
      response
    end

    let(:user) { FactoryBot.create(:user) }

    context 'when everything is ok' do
      it 'returns a 200' do
        expect(do_create).to have_http_status(:ok)
      end

      it 'creates a new clock with nil clock_out and duration' do
        do_create
        expect(user.clocks.last.clock_out).to be_nil
        expect(user.clocks.last.duration).to be_nil
      end

      it 'returns all the clocks of the user ordered desc by clock_in' do
        expect(do_create.body).to eq({ clocks: user.clocks.order(clock_in: :desc) }.to_json)
      end
    end
  end

  describe 'PUT /update' do
    subject(:do_update) do
      put "/users/#{user.id}/clock_out"
      response
    end

    let(:user) { FactoryBot.create(:user) }

    context 'when everything is ok' do
      before do
        FactoryBot.create(:clock, user_id: user.id, clock_in: 3.hour.ago)
        Clock.create(user_id: user.id, clock_in: 1.hour.ago)
      end

      it 'returns a 200' do
        expect(do_update).to have_http_status(:ok)
      end

      it 'returns all the clocks of the user ordered desc by clock_in' do
        expect(do_update.body).to eq({ clocks: user.clocks.order(clock_in: :desc) }.to_json)
      end
    end

    context "when there's no any clock waiting clock_out" do
      it 'returns a 404' do
        expect(do_update).to have_http_status(:not_found)
      end

      it 'returns NO_ACTIVE_CLOCK error code' do
        expect(do_update.body).to eq({ error_code: 'NO_ACTIVE_CLOCK' }.to_json)
      end
    end
  end
end

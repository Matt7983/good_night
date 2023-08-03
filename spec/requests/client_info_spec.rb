require 'rails_helper'

RSpec.describe "ClientInfos", type: :request do
  describe "GET /index" do
    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return('1.1.1.1')

      get '/client_info'
    end

    it 'should return 200' do
      expect(response).to have_http_status(200)
    end

    it "should return ip address" do
      expect(response.body).to eq({ ip: '1.1.1.1' }.to_json)
    end
  end
end

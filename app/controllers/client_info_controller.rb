class ClientInfoController < ApplicationController
  def index
    render json: { ip: remote_ip }
  end
end

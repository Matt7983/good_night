class ApplicationController < ActionController::API
  def remote_ip
    @remote_ip ||=
      (request.headers['X-Forwarded-For'] || '').split(',').first.try(:strip) ||
      request.remote_ip
  end
end

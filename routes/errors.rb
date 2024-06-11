# frozen_string_literal: true

require 'sinatra/base'

class Errors < Sinatra::Base
  error 401 do
    content_type :json
    status 401
    { message: 'Access forbidden' }.to_json
  end

  error 400 do
    content_type :json
    status 400
    { message: 'Bad request' }.to_json
  end

  error 403 do
    content_type :json
    status 403
    { message: 'Your role is insufficient' }.to_json
  end

  error 404 do
    content_type :json
    status 404
    { message: 'Lost?' }.to_json
  end
end

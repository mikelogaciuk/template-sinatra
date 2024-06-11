require_relative '../app'
require 'test/unit'
require 'rack/test'

class AdminTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Api
  end

  def test_users_list_route
    get '/api/admin/users/list'
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    assert_includes last_response.body, 'users'
  end

  def test_users_exists_route
    get '/api/admin/users/exists', email: 'test@example.com'
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    assert_includes last_response.body, 'exists'
  end

  def test_users_create_route
    post '/api/admin/users/create', email: 'test@example.com', password: 'password'
    assert last_response.created?
    assert_equal 'application/json', last_response.content_type
    assert_includes last_response.body, 'User created'
  end

  def test_users_delete_route
    delete '/api/admin/users/delete', email: 'test@example.com'
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    assert_includes last_response.body, 'User deleted'
  end

  def test_users_activate_route
    post '/api/admin/users/activate', email: 'test@example.com'
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    assert_includes last_response.body, 'User activated'
  end
end

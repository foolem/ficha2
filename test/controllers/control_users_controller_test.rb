require 'test_helper'

class ControlUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get control_users_index_url
    assert_response :success
  end

end

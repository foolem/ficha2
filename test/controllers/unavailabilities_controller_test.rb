require 'test_helper'

class UnavailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unavailability = unavailabilities(:one)
  end

  test "should get index" do
    get unavailabilities_url
    assert_response :success
  end

  test "should get new" do
    get new_unavailability_url
    assert_response :success
  end

  test "should create unavailability" do
    assert_difference('Unavailability.count') do
      post unavailabilities_url, params: { unavailability: { availability_id: @unavailability.availability_id, comments: @unavailability.comments, schedule_id: @unavailability.schedule_id } }
    end

    assert_redirected_to unavailability_url(Unavailability.last)
  end

  test "should show unavailability" do
    get unavailability_url(@unavailability)
    assert_response :success
  end

  test "should get edit" do
    get edit_unavailability_url(@unavailability)
    assert_response :success
  end

  test "should update unavailability" do
    patch unavailability_url(@unavailability), params: { unavailability: { availability_id: @unavailability.availability_id, comments: @unavailability.comments, schedule_id: @unavailability.schedule_id } }
    assert_redirected_to unavailability_url(@unavailability)
  end

  test "should destroy unavailability" do
    assert_difference('Unavailability.count', -1) do
      delete unavailability_url(@unavailability)
    end

    assert_redirected_to unavailabilities_url
  end
end

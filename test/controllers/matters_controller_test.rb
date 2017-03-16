require 'test_helper'

class MattersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @matter = matters(:one)
  end

  test "should get index" do
    get matters_url
    assert_response :success
  end

  test "should get new" do
    get new_matter_url
    assert_response :success
  end

  test "should create matter" do
    assert_difference('Matter.count') do
      post matters_url, params: { matter: { description: @matter.description, name: @matter.name, workload: @matter.workload } }
    end

    assert_redirected_to matter_url(Matter.last)
  end

  test "should show matter" do
    get matter_url(@matter)
    assert_response :success
  end

  test "should get edit" do
    get edit_matter_url(@matter)
    assert_response :success
  end

  test "should update matter" do
    patch matter_url(@matter), params: { matter: { description: @matter.description, name: @matter.name, workload: @matter.workload } }
    assert_redirected_to matter_url(@matter)
  end

  test "should destroy matter" do
    assert_difference('Matter.count', -1) do
      delete matter_url(@matter)
    end

    assert_redirected_to matters_url
  end
end

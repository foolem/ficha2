require 'test_helper'

class UniteGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unite_group = unite_groups(:one)
  end

  test "should get index" do
    get unite_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_unite_group_url
    assert_response :success
  end

  test "should create unite_group" do
    assert_difference('UniteGroup.count') do
      post unite_groups_url, params: { unite_group: { name: @unite_group.name } }
    end

    assert_redirected_to unite_group_url(UniteGroup.last)
  end

  test "should show unite_group" do
    get unite_group_url(@unite_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_unite_group_url(@unite_group)
    assert_response :success
  end

  test "should update unite_group" do
    patch unite_group_url(@unite_group), params: { unite_group: { name: @unite_group.name } }
    assert_redirected_to unite_group_url(@unite_group)
  end

  test "should destroy unite_group" do
    assert_difference('UniteGroup.count', -1) do
      delete unite_group_url(@unite_group)
    end

    assert_redirected_to unite_groups_url
  end
end

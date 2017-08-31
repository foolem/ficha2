require 'test_helper'

class UniteMattersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unite_matter = unite_matters(:one)
  end

  test "should get index" do
    get unite_matters_url
    assert_response :success
  end

  test "should get new" do
    get new_unite_matter_url
    assert_response :success
  end

  test "should create unite_matter" do
    assert_difference('UniteMatter.count') do
      post unite_matters_url, params: { unite_matter: { name: @unite_matter.name } }
    end

    assert_redirected_to unite_matter_url(UniteMatter.last)
  end

  test "should show unite_matter" do
    get unite_matter_url(@unite_matter)
    assert_response :success
  end

  test "should get edit" do
    get edit_unite_matter_url(@unite_matter)
    assert_response :success
  end

  test "should update unite_matter" do
    patch unite_matter_url(@unite_matter), params: { unite_matter: { name: @unite_matter.name } }
    assert_redirected_to unite_matter_url(@unite_matter)
  end

  test "should destroy unite_matter" do
    assert_difference('UniteMatter.count', -1) do
      delete unite_matter_url(@unite_matter)
    end

    assert_redirected_to unite_matters_url
  end
end

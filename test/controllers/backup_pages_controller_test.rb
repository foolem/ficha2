require 'test_helper'

class BackupPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @backup_page = backup_pages(:one)
  end

  test "should get index" do
    get backup_pages_url
    assert_response :success
  end

  test "should get new" do
    get new_backup_page_url
    assert_response :success
  end

  test "should create backup_page" do
    assert_difference('BackupPage.count') do
      post backup_pages_url, params: { backup_page: {  } }
    end

    assert_redirected_to backup_page_url(BackupPage.last)
  end

  test "should show backup_page" do
    get backup_page_url(@backup_page)
    assert_response :success
  end

  test "should get edit" do
    get edit_backup_page_url(@backup_page)
    assert_response :success
  end

  test "should update backup_page" do
    patch backup_page_url(@backup_page), params: { backup_page: {  } }
    assert_redirected_to backup_page_url(@backup_page)
  end

  test "should destroy backup_page" do
    assert_difference('BackupPage.count', -1) do
      delete backup_page_url(@backup_page)
    end

    assert_redirected_to backup_pages_url
  end
end

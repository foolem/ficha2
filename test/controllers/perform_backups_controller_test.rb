require 'test_helper'

class PerformBackupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @perform_backup = perform_backups(:one)
  end

  test "should get index" do
    get perform_backups_url
    assert_response :success
  end

  test "should get new" do
    get new_perform_backup_url
    assert_response :success
  end

  test "should create perform_backup" do
    assert_difference('PerformBackup.count') do
      post perform_backups_url, params: { perform_backup: {  } }
    end

    assert_redirected_to perform_backup_url(PerformBackup.last)
  end

  test "should show perform_backup" do
    get perform_backup_url(@perform_backup)
    assert_response :success
  end

  test "should get edit" do
    get edit_perform_backup_url(@perform_backup)
    assert_response :success
  end

  test "should update perform_backup" do
    patch perform_backup_url(@perform_backup), params: { perform_backup: {  } }
    assert_redirected_to perform_backup_url(@perform_backup)
  end

  test "should destroy perform_backup" do
    assert_difference('PerformBackup.count', -1) do
      delete perform_backup_url(@perform_backup)
    end

    assert_redirected_to perform_backups_url
  end
end

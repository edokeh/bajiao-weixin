# -*- encoding : utf-8 -*-
require 'test_helper'

class StaffPhotosControllerTest < ActionController::TestCase
  setup do
    @staff_photo = staff_photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:staff_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create staff_photo" do
    assert_difference('StaffPhoto.count') do
      post :create, staff_photo: { content_type: @staff_photo.content_type, file: @staff_photo.file, file_name: @staff_photo.file_name, file_size: @staff_photo.file_size, staff_id: @staff_photo.staff_id }
    end

    assert_redirected_to staff_photo_path(assigns(:staff_photo))
  end

  test "should show staff_photo" do
    get :show, id: @staff_photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @staff_photo
    assert_response :success
  end

  test "should update staff_photo" do
    put :update, id: @staff_photo, staff_photo: { content_type: @staff_photo.content_type, file: @staff_photo.file, file_name: @staff_photo.file_name, file_size: @staff_photo.file_size, staff_id: @staff_photo.staff_id }
    assert_redirected_to staff_photo_path(assigns(:staff_photo))
  end

  test "should destroy staff_photo" do
    assert_difference('StaffPhoto.count', -1) do
      delete :destroy, id: @staff_photo
    end

    assert_redirected_to staff_photos_path
  end
end

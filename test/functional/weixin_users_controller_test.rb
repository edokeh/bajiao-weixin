# -*- encoding : utf-8 -*-
require 'test_helper'

class WeixinUsersControllerTest < ActionController::TestCase
  setup do
    @weixin_user = weixin_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weixin_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weixin_user" do
    assert_difference('WeixinUser.count') do
      post :create, weixin_user: { nick: @weixin_user.nick, remark: @weixin_user.remark, weixin_id: @weixin_user.weixin_id }
    end

    assert_redirected_to weixin_user_path(assigns(:weixin_user))
  end

  test "should show weixin_user" do
    get :show, id: @weixin_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weixin_user
    assert_response :success
  end

  test "should update weixin_user" do
    put :update, id: @weixin_user, weixin_user: { nick: @weixin_user.nick, remark: @weixin_user.remark, weixin_id: @weixin_user.weixin_id }
    assert_redirected_to weixin_user_path(assigns(:weixin_user))
  end

  test "should destroy weixin_user" do
    assert_difference('WeixinUser.count', -1) do
      delete :destroy, id: @weixin_user
    end

    assert_redirected_to weixin_users_path
  end
end

# -*- encoding : utf-8 -*-
# -coding: utf-8 -
class Admin::WeixinUsersController < Admin::ApplicationController
  # GET /weixin_users
  # GET /weixin_users.json
  def index
    @weixin_users = WeixinUser.all
  end

  # GET /weixin_users/1
  # GET /weixin_users/1.json
  def show
    @weixin_user = WeixinUser.find(params[:id])
  end

  # GET /weixin_users/1/edit
  def edit
    @weixin_user = WeixinUser.find(params[:id])
  end

  # PUT /weixin_users/1
  # PUT /weixin_users/1.json
  def update
    @weixin_user = WeixinUser.find(params[:id])

    if @weixin_user.update_attributes(params[:weixin_user])
      redirect_to admin_weixin_users_url, :notice => '修改成功！'
    else
      render :action => "edit"
    end
  end
end

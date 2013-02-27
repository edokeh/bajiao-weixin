# -*- encoding : utf-8 -*-
class Admin::WeixinUsersController < Admin::ApplicationController
  def index
    @weixin_users = WeixinUser.all
  end

  def edit
    @weixin_user = WeixinUser.find(params[:id])
  end

  def update
    @weixin_user = WeixinUser.find(params[:id])

    if @weixin_user.update_attributes(params[:weixin_user])
      redirect_to admin_weixin_users_url, :notice => '修改成功！'
    else
      render :action => "edit"
    end
  end
end

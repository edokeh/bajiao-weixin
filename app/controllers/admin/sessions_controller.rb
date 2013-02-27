# -*- encoding : utf-8 -*-
class Admin::SessionsController < ApplicationController
  layout nil

  #登录页面
  def new
    redirect_to '/admin' if is_admin?
  end

  def create
    if params[:password] == Rails.configuration.admin_pass
      session[:admin] = true
      redirect_to '/admin/staffs'
    else
      flash[:error] = '密码错误！'
      redirect_to :action=>'new'
    end
  end

  def destroy
    session[:admin] = nil
    redirect_to :action=>:new
  end
end

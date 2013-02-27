# -*- encoding : utf-8 -*-
class Weixin::HomeController < Weixin::ApplicationController
  skip_before_filter :check_weixin_user, :only => [:show]

  # 欢迎信息
  def show
    render :text => params[:echostr]
  end

  # 欢迎信息
  def welcome
  end
end

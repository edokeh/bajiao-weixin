# -*- encoding : utf-8 -*-
class Weixin::ApplicationController < ActionController::Base
  layout "weixin"
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality
  before_filter :check_weixin_user

  private
  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  # 检查微信用户是否合法
  def check_weixin_user
    @weixin_user = WeixinUser.firstCreate(weixin_xml)
    render "weixin/403", :formats => :xml unless @weixin_user.is_valid?
  end

end

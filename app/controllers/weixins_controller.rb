# -*- encoding : utf-8 -*-
class WeixinsController < ApplicationController
  layout "weixin"
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality
  before_filter :check_weixin_user, :only => [:create]

  # 校验
  def show
    render :text => params[:echostr]
  end

  # 用户发送消息
  def create
    query_type = params[:xml][:MsgType]
    if query_type == "image"
      submit_photo(params[:xml])
    elsif query_type == "text"
      query = params[:xml][:Content]
      if query == "Hello2BizUser"
        welcome
      elsif query.start_with?("@")
        staff_show(query[1..-1])
      elsif query.start_with?("#photo ")
        change_photo(query)
      elsif query == "test"
        render "test", :formats => :xml
      else
        staff_index(query)
      end
    else
      logger.error("### wrong type #{params[:xml][:MsgType]} ###")
    end
  end

  private

  # 根据参数校验请求是否合法，如果非法返回错误页面
  def check_weixin_legality
    array = [Rails.configuration.weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end

  # 检查微信用户是否合法
  def check_weixin_user
    @weixin_user = WeixinUser.firstCreate(params[:xml])
    render "403", :formats => :xml unless @weixin_user.is_valid?
  end

  # 查找所有员工
  def staff_index(query)
    @staffs = Staff.where(["workno=? or phone=? or username=? or pinyin=? or name=? ", query, query, query, query, query]).limit(5)
    if @staffs.empty?
      render "weixins/staff/not_found", :formats => :xml
    else
      render "weixins/staff/index", :formats => :xml
    end
  end

  # 根据工号展示某个员工
  def staff_show(query)
    @staff = Staff.where(["workno=?", query]).first
    if @staff.nil?
      render "weixins/staff/not_found", :formats => :xml
    else
      render "weixins/staff/show", :formats => :xml
    end
  end

  # 欢迎信息
  def welcome
    render "home", :formats => :xml
  end

  # 图片投稿
  def submit_photo(msg)
    @photo = StaffPhoto.new_by_msg(msg)
    render "weixins/photo/create", :formats => :xml
  end

  # 改变图片的归属
  def change_photo(query)
    workno = query.split(' ')[1]
    @staff = Staff.where(:workno=>workno).first
    photo = @weixin_user.tmp_photo
    if @staff.present? and photo.present?
      photo.update_attribute(:staff_workno, workno)
      @weixin_user.update_attribute(:tmp_photo_id, nil)
      render "weixins/photo/update", :formats => :xml
    else
      render "weixins/photo/error", :formats => :xml
    end
  end

end

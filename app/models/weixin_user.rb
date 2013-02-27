# -*- encoding : utf-8 -*-
class WeixinUser < ActiveRecord::Base
  S_INVALID = 1 # 未通过
  S_VALID = 2 # 通过审核

  attr_accessible :nick, :remark, :weixin_id, :status, :query_count

  belongs_to :tmp_photo, :class_name => "StaffPhoto", :foreign_key => :tmp_photo_id

  # 初始创建用户，如果有了则不重复创建
  def self.firstCreate(xml)
    user = WeixinUser.where(:weixin_id => xml.from_user).first
    if user.nil?
      user = WeixinUser.create(:weixin_id => xml.from_user,
                               :status => S_INVALID, :query_count => 0,
                               :remark => Time.now.to_s + "\r\n" + xml.content)
    end
    return user
  end

  def is_valid?
    return status != S_INVALID
  end
end

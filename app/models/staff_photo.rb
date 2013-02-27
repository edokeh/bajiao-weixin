# -*- encoding : utf-8 -*-
require 'net/http'
Net::HTTP.version_1_2

class StaffPhoto < ActiveRecord::Base
  S_INVALID = 1 # 未通过
  S_VALID = 2 # 通过审核

  attr_accessible :file, :staff_workno, :weixin_user_id

  belongs_to :staff, :foreign_key => "staff_workno", :primary_key => "workno"
  belongs_to :weixin_user

  before_create :resize_photo

  paginates_per 50

  validate :valid_file_size

  scope :valid, where(:status => S_VALID)

  # 根据上传数据新建
  def self.new_by_upload(params)
    photo = StaffPhoto.new(params)
    photo.file_name = params[:file].try(:original_filename)
    photo.content_type = params[:file].content_type
    photo.status = S_INVALID
    return photo
  end

  # 根据微信消息新建
  def self.new_by_msg(msg)
    photo = StaffPhoto.new
    weixin_user = WeixinUser.where(:weixin_id => msg.from_user).first
    photo.weixin_user_id = weixin_user.id
    photo.file_name = msg.pic_url
    photo.status = S_INVALID

    # 5秒限制
    Thread.new do
      file = Net::HTTP.get(URI(msg.pic_url))
      photo.file = file
      photo.content_type = "image/jpeg"
      photo.file_size = file.length
      photo.save
    end

    photo.save
    weixin_user.update_attribute(:tmp_photo_id, photo.id)
    return photo
  end

  # 校验文件大小
  def valid_file_size
    errors[:file] << "不能超过 1MB" if file.present? and file.size > 1.megabytes
  end

  # 调整图片尺寸
  def resize_photo
    return if file.blank?
    img = MiniMagick::Image.read(file)
    img.resize "300x400>"
    self.file = img.to_blob
    self.file_size = img.to_blob.length
  end

  def is_valid?
    return status != S_INVALID
  end
end

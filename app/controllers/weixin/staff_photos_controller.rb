# -*- encoding : utf-8 -*-
class Weixin::StaffPhotosController < Weixin::ApplicationController

  # 图片投稿
  def create
    @photo = StaffPhoto.new_by_msg(weixin_xml)
  end

  # 改变图片的归属
  def update
    workno = weixin_xml.content.split(' ')[1]
    @staff = Staff.where(:workno => workno).first
    photo = @weixin_user.tmp_photo
    if @staff.present? and photo.present?
      photo.update_attribute(:staff_workno, workno)
      @weixin_user.update_attribute(:tmp_photo_id, nil)
      render "update"
    else
      render "error"
    end
  end

end

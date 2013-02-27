# -*- encoding : utf-8 -*-
# 重置数据的接口，接收程序提交的最新员工数据、照片
class Admin::RosterResetController < Admin::ApplicationController
  skip_before_filter :verify_authenticity_token

  # 根据提交的HTML文件重置员工数据
  def staff
    html = params[:file].read
    staffs = RosterHtmlParser.parse(html)
    Staff.transaction do
      Staff.delete_all
      Staff.create(staffs.map { |staff| staff.except(:img_url) })
    end

    puts staffs.select{|s| s[:img_url].nil? }

    # 返回没有图片的 staff
    workno_without_photo = Staff.find_by_sql("SELECT * FROM staffs s WHERE NOT EXISTS (SELECT * FROM staff_photos WHERE staff_photos.staff_workno = s.workno)").map(&:workno)
    render :json => staffs.select{|s| workno_without_photo.include?(s[:workno])}
  end

  # 提交员工照片
  def photo
    photo = StaffPhoto.new_by_upload(params)
    photo.status = StaffPhoto::S_VALID

    if photo.save
      render :text => photo.id
    else
      render :text => "error"
    end
  end
end

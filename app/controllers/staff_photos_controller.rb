# -*- encoding : utf-8 -*-
class StaffPhotosController < ApplicationController
  # 具体图片
  def show
    @staff_photo = StaffPhoto.find(params[:id])

    send_data @staff_photo.file, :type => @staff_photo.content_type, :disposition => 'inline'
  end
end

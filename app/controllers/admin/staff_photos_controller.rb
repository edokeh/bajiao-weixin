# -*- encoding : utf-8 -*-
class Admin::StaffPhotosController < Admin::ApplicationController

  def index
    @staff_photos = StaffPhoto.order("created_at DESC")
    @staff_photos = @staff_photos.where(:status=>params[:status]) if params[:status].present?
    @staff_photos = @staff_photos.page(params[:page])
  end

  def destroy
    @staff_photo = StaffPhoto.find(params[:id])
    @staff_photo.destroy

    redirect_to :back
  end

  def create
    @photo = StaffPhoto.new_by_upload(params)

    if @photo.save
      redirect_to :action => "index"
    else
      render :action => "index"
    end
  end

  def change_valid
    @staff_photo = StaffPhoto.find(params[:id])
    @staff_photo.update_attribute(:status, @staff_photo.is_valid? ? StaffPhoto::S_INVALID : StaffPhoto::S_VALID)

    redirect_to :back
  end
end

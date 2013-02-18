class Admin::StaffsController < Admin::ApplicationController

  def index
    @staffs = Staff.page(params[:page])
  end
end

# -*- encoding : utf-8 -*-
class StaffsController < ApplicationController
  def show
    @staff = Staff.where(:workno=>params[:id]).first
  end
end

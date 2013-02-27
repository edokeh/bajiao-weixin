# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :is_admin?

  def is_admin?
    return session[:admin] == true
  end
end

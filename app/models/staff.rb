# -*- encoding : utf-8 -*-
class Staff < ActiveRecord::Base
  attr_accessible :name, :workno, :phone, :email, :dept, :duty, :username, :pinyin

  has_many :staff_photos, :foreign_key=>"staff_workno", :primary_key=>"workno"

  paginates_per 200
end

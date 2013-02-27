# -*- encoding : utf-8 -*-
class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :workno
      t.string :phone
      t.string :email
      t.string :dept
      t.string :duty
      t.string :username
      t.string :pinyin

      t.timestamps
    end
  end
end

# -*- encoding : utf-8 -*-
class AddWeixinUserField < ActiveRecord::Migration
  def up
    add_column :weixin_users, :tmp_photo_id, :integer  # 上传图片时临时保存的图片id
  end

  def down
    remove_column :weixin_users, :tmp_photo_id
  end
end

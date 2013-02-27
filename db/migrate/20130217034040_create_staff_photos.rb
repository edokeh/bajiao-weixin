# -*- encoding : utf-8 -*-
class CreateStaffPhotos < ActiveRecord::Migration
  def change
    create_table :staff_photos do |t|
      t.column :file, :binary, :limit => 2.megabyte
      t.string :file_name
      t.string :content_type
      t.integer :file_size
      t.string :staff_workno
      t.integer :weixin_user_id
      t.integer :status

      t.timestamps
    end
  end
end

# -*- encoding : utf-8 -*-
class CreateWeixinUsers < ActiveRecord::Migration
  def change
    create_table :weixin_users do |t|
      t.string :weixin_id
      t.string :nick
      t.string :remark
      t.integer :status # 审核状态
      t.integer :query_count # 查询次数

      t.timestamps
    end
  end
end

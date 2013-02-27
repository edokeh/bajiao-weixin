# -*- encoding : utf-8 -*-
class Weixin::StaffsController < Weixin::ApplicationController

  # 查找所有员工
  def index
    query = weixin_xml.content
    @staffs = Staff.where(["workno=? or phone=? or username=? or pinyin=? or name=? ", query, query, query, query, query]).limit(5)
    if @staffs.empty?
      render "not_found"
    else
      render "index"
    end
  end

  # 根据工号展示某个员工
  def show
    query = weixin_xml.content[1..-1]
    @staff = Staff.where(["workno=?", query]).first
    if @staff.nil?
      render "not_found"
    else
      render "show"
    end
  end

end

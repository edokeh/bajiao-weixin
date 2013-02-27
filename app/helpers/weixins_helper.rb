# -*- encoding : utf-8 -*-
# -coding: utf-8 -
module WeixinsHelper
  # 补全工号前面的0
  def pretty_workno(workno)
    "0" * (6 - workno.length) + workno
  end
end

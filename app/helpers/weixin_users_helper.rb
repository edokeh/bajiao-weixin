# -*- encoding : utf-8 -*-
# -coding: utf-8 -
module WeixinUsersHelper

  def status_desc(weixin_user)
    case weixin_user.status
      when WeixinUser::S_INVALID
        "未通过"
      when WeixinUser::S_VALID
        "通过"
    end
  end
end

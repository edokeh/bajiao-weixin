# -*- encoding : utf-8 -*-
require "hpricot"
require_relative "pinyin"

# 解析员工通讯录页面的类
class RosterHtmlParser

  # 解析，返回解析后的数据结构
  def self.parse(html)
    arr = html_to_array(html)
    staffs = arr.map { |tds| parse_td(tds) }

    # 处理一下部门
    staffs.each.with_index do |staff, index|
      if staff[:dept] == '""'
        staff[:dept] = staffs[index - 1][:dept]
      end
    end

    return staffs
  end

  # 将html解析为二维数组结构
  def self.html_to_array(html)
    doc = Hpricot(html.force_encoding("GBK").encode("UTF-8"))
    staffs = []
    trs=doc.search("//table[@id='PowerTable']/tr").each_with_index do |tr, index|
      next if index == 0
      staffs << tr.search("td")
    end
    return staffs
  end

  # 解析 tds 数组，返回 hash {:dept, :duty, :phone, :email, :img_url, :work_no, :name}
  def self.parse_td(tds)
    staff = {
        :dept => tds[1].inner_text,
        :duty => tds[3].inner_text,
        :phone => tds[4].inner_text
    }
    # 职务
    if staff[:duty].index("...")
      staff[:duty] = tds[3].at("a")["title"]
    end
    # email 域账号
    staff[:email] = tds[7].at("a")["href"][7..-1]
    staff[:username] = staff[:email].split('@')[0]
    # 照片
    if tds[8].at("img")
      photo = Hpricot(tds[8].at("img")["alt"])
      staff[:img_url] = photo.at("img")["src"]
    end
    # 姓名，工号，拼音
    workno_and_name = tds[2].inner_text
    staff[:workno] = workno_and_name[1, 6].to_i.to_s
    staff[:name] = workno_and_name[9..-1].gsub("　", "")
    pinyin_arr = Pinyin.from_hanzi(staff[:name])
    staff[:pinyin] = choose_pinyin_by_username(staff[:username], pinyin_arr)

    return staff
  end

  # 对于多音字的情况，根据域账号尝试剔除多余的拼音
  def self.choose_pinyin_by_username(username, pinyin_arr)
    result = []
    # 只针对有多音字的情况
    if pinyin_arr.length > 0
      #去掉分公司前缀
      %w(nj dg fs szh sh shz wuxi gz qd zhsh jm qz zhjg nb hz wz jh tz sch nt yz wh).each do |area|
        username.gsub!(area + "-", "")
      end
      pinyin_arr.each do |pinyin|
        reg = ""
        pinyin.each_char { |c| reg += c + ".*" }
        result << pinyin if username =~ Regexp.new(reg, Regexp::IGNORECASE)
      end
      # 也可能没有任何拼音匹配正确，这是因为域账号不是名字简拼
      # 比如 jshen-SJH，不过一般都不要紧，因为他们的拼音中没有多音字
      if result.length == 0
        # 只有一个人是例外，我也很无奈
        if username == "cissy"
          result = ["WQ"]
        else
          result = pinyin_arr
        end
      end
    else
      result = pinyin_arr
    end

    return result[0]
  end
end

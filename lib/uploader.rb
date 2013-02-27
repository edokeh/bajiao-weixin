# -*- encoding : utf-8 -*-
require 'net/http'
require 'net/http/post/multipart'
require 'json'
require_relative "roster_html_parser"

Net::HTTP.version_1_2
HOST = 'http://192.168.153.128:3000' || 'http://bajiao.cloudfoundry.com'

# 登录OA并获取html
def get_roster_html
  puts "enter mic key:"
  mickey = gets
  html = ''
  Net::HTTP.start('oa.vemic.com') do |http|
    response = http.post('/index/login.php', "username=geliang&password=geliangb&dpwd=#{mickey}&submit_flag=login")
    if response['location']
      cookie = response['set-cookie']
      puts "login OA and get cookie !"
      header = {
          #'Accept-Encoding'=>'gzip, deflate',
          'Cookie' => cookie,
          'robot' => "Chaos"
      }
      html = http.get('/myfocus/address_old.php', header).body.to_s
    end
  end
  return html
end


# 登录bajiao
def login_bajiao(password)
  login_url = URI(HOST + "/admin/session")
  Net::HTTP.start(login_url.host, login_url.port) do |http|
    response = http.post(login_url.path, "password=#{password}")
    if response['location']
      cookie = response['set-cookie']
      puts "login bajiao and get cookie !"
      return cookie
    end
  end
end

# 上传 HTML
def upload_html(html_file, cookie)
  staff_url = URI.parse(HOST + '/admin/roster_reset/staff')
  post_data = {"file" => UploadIO.new(html_file, "text/html", "roster.html")}
  header = {"Cookie" => cookie}
  req = Net::HTTP::Post::Multipart.new(staff_url.path, post_data, header)
  res = Net::HTTP.start(staff_url.host, staff_url.port) do |http|
    http.request(req)
  end
  json = JSON.parse(res.body)
  puts "staff ok! #{json.size} photo need upload!"
  return json
end

# 上传照片
def upload_photo(url, workno, cookie)
  puts url
  photo_url = URI.parse(HOST + '/admin/roster_reset/photo')
  file = StringIO.new(Net::HTTP.get('oa.vemic.com', "/myfocus/" + url))
  post_data = {"file" => UploadIO.new(file, "image/jpeg", '@avatar_' + workno + '.jpg'), "staff_workno" => workno}
  header = {"Cookie" => cookie}
  req = Net::HTTP::Post::Multipart.new(photo_url.path, post_data, header)
  res = Net::HTTP.start(photo_url.host, photo_url.port) do |http|
    http.request(req)
  end
  puts "upload ##{workno} #{res.body}"
end


#cookie = login_bajiao('test')
#file = StringIO.new(get_roster_html)
#staff_json = upload_html(file, cookie)
#staff_json.each do |staff|
#  next if staff["img_url"].nil?
#  upload_photo(staff["img_url"], staff["workno"], cookie)
#end

#file = get_roster_html
#staffs = RosterHtmlParser.parse(file)
#puts staffs.select{|s| s[:img_url].nil? }
cookie = login_bajiao('test')
file = File.open('./A.htm')
staff_json = upload_html(file, cookie)
staff_json.each do |staff|
  next if staff["img_url"].nil?
  upload_photo(staff["img_url"], staff["workno"], cookie)
end

require 'net/http'
require 'cgi'

module SqlRuForumHelper

  UAGENT = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.36"
 COO = "ASP.NET_SessionId=x0dfwbu322wohrxpiactxoux; af_remember=a16695ff-7e2d-4d4a-8b7b-58102d49c426; af_data=lvdt=635969424136532787"


  def self.get_hash(fid,tid)
    ticks = Time.now.to_i
    path = "http://www.sql.ru/forum/afservice.aspx?action=ph&qasw=#{ticks}&b=#{fid}&t=#{tid}"

    uri = URI(path)
    http = Net::HTTP.new(uri.host, 80)

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Cookie'] = COO # <---
    res = http.request(request)
    res.body
  end



  def self.post(fid, tid, mid, title, text)

    path = "http://www.sql.ru/forum/actualpost.aspx?bid=#{fid}&tid=#{tid}&mid=#{mid}&p=1"
    uri = URI(path)
    http = Net::HTTP.new(uri.host, 80)

    request = Net::HTTP::Post.new(uri.request_uri)
    request['Cookie'] = COO
    request['User-Agent'] = UAGENT
    request['Referer'] = "http://www.sql.ru/forum/actualpost.aspx?bid=#{fid}&tid=#{tid}&mid=#{mid}&p=1"
    hash = get_hash(fid,tid)


    post_data = "
tid=#{tid}
&bid=#{fid}
&mid=0
&act  
&hash=#{hash}
&p=1

&topicicon=0
&subject=#{title}
  
&message=#{text}
&post=Опубликовать"

    request.body = post_data.encode("windows-1251")
    res = http.request(request)
    puts "***forum_helper*** response_code: #{res.code}"
  end

end

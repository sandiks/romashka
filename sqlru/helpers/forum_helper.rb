require 'net/http'
require 'cgi'
require_relative  'tor'

module SqlRuForumHelper

  UAGENT = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.73 Safari/537.36"
  COO = "ASP.NET_SessionId=3rm4lpkpyfe5xmqsp2xtm0tq; af_data=lvdt=636003129902983487; af_remember=c54cf03f-9371-4f86-80ba-bc0ebd85"


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
  def self.get_hash_mech(fid,tid)
    ticks = Time.now.to_i
    path = "http://www.sql.ru/forum/afservice.aspx?action=ph&qasw=#{ticks}&b=#{fid}&t=#{tid}"

    headers = { 'User-Agent' => UAGENT , 'Cookie'=> COO}
    a = Mechanize.new

    uri = URI(path)
    res = a.get(uri,headers)
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



    t=Tor.new
    t.proxy_mechanize {
      request.body = post_data.encode("windows-1251")
      res = http.request(request)
    }
  end


  def self.post_mechanize(fid, tid, mid, title, text)

    path = "http://www.sql.ru/forum/actualpost.aspx?bid=#{fid}&tid=#{tid}&mid=#{mid}&p=1"

    headers = { 'User-Agent' => UAGENT , 'Cookie'=> COO , 'Referer'=> "http://www.sql.ru/forum/actualpost.aspx?bid=#{fid}&tid=#{tid}&mid=#{mid}&p=1"}

    uri = URI(path)

    hash = get_hash(fid,tid)

    postd={
      "tid"=>tid,
      "bid"=>fid,
      "mid"=>0,
      "act"=>"",
      "hash"=>hash,
      "p"=>1,
      "topicicon"=>0,
      "subject"=>title,
      "message"=>text,
      "post"=>"Опубликовать",
    }
    agent = Mechanize.new
    p agent.post(uri,postd,headers)
    #request.body = post_data.encode("windows-1251")
    #res = http.request(request)
  end

end

def test
  tid=1213244
  mid=19152587
  title="Re: Пока меня не было на ПТ, Аклин насувал кирпичей Деду за воротник."
  text="кидацца кирпицами"
  SqlRuForumHelper.post(16,tid,mid,title,text)
end

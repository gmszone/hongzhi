require 'rubygems'
require 'json'
require 'net/http'
require 'nokogiri'

class BlogHelper
  def getdata(query)
    result = []
    response = Net::HTTP.get_response("www.xuntayizhan.com","/?wpapi=search&dev=1&keyword="+query)
    posts = (JSON.parse response.body)['posts']
    count = (JSON.parse response.body)['count']
    posts = posts.take(8)
    posts.each do |post,index|
       if index == 1
         post_id = post['id']
         image_response = Net::HTTP.get_response("www.xuntayizhan.com","/?wpapi=get_posts&dev=1&comment=1&content=1&id="+post_id)
         image_response_content = (JSON.parse image_response.body)['posts'][0]['content']
         if Nokogiri::HTML(image_response_content).at_css('img')
           image_req = Nokogiri::HTML(image_response_content).css('img').first['src']
         end
       end
       image_req = 'http://www.xuntayizhan.com/xt.jpg'
       result << {
         :title => post['title'],
          :description => /&hellip;/.match(post['excerpt']).pre_match,
        :picture_url => image_req,
          :url => post['url']
        }
    end
    if result.size == 0
        result << {
        :title => "对不起，找不到相关内容",
        :description => "若您有兴趣，可以向我们提供相关文章",
        :picture_url => "http://www.xuntayizhan.com/404.jpg",
        :url => "https://jinshuju.net/f/M2UDXi",
        }
    end
    p result
    result
  end
end

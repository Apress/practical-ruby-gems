require 'camping'
require 'feed_tools'
require 'uri'


Camping.goes :News

module News::Controllers
  class Index < R '/'
    def get  
      render :frontpage
    end
  end
end

module News::Views
  @@search_term= 'ruby on rails'
  def frontpage
    h1 "News about #{@@search_term.titlecase}"

    ul do
      url="http://news.search.yahoo.com/news/rss?" << 
          "ei=UTF-8&p=#{URI.encode(@@search_term)}&eo=UTF-8"
      feed=FeedTools::Feed.open(url)

      feed.items.each do |feed_item|
        div do
          a :href=>feed_item.link do
            feed_item.title
          end
        end
      end
    end
  end
end


require 'camping'
require 'feed_tools'

# URI is a module built into Ruby for manipulating URIs;
# we'll use it for encoding our data into our
# Google search URL. You can get more details here:
#
# http://www.ruby-doc.org/stdlib/libdoc/uri/rdoc/index.html
#

require 'uri'
require 'shorturl'

Camping.goes :ShortBlogs

# This module contains our single view, frontpage.

module ShortBlogs::Controllers
  class Frontpage < R '/'
    def get
      render :frontpage
    end
  end
end

module ShortBlogs::Views

  @@search_term= 'ruby on rails'
  @@number_of_results = 15

  def frontpage
    h1 "Blogs about #{@@search_term.titlecase}"

    # Create a Google blog search URL from our
    # search term, and then pull the RSS items
    # from it.

    url =  "http://blogsearch.google.com/blogsearch_feeds?"
    url << "hl=en&q=#{URI.encode(@@search_term)}&ie=utf-8"
    url << "&num=#{@@number_of_results}&output=rss&scoring=d"

    feed=FeedTools::Feed.open(url)

      # Loop through each item, and
      # print out a shortened link to it.

      feed.items.each do |feed_item|
        url=WWW::ShortURL.shorten(feed_item.link)
        div do
          a(:href=>url) {feed_item.title} << ' - ' << url
        end
      end

    end
end


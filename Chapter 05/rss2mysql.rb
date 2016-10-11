require 'active_record'
require 'feed_tools'

feed_url = ARGV[0]

# This call creates a connection to our database.

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "127.0.0.1",
  :username => "root", # Note that while this is the default setting for MySQL,
  :password => "",  # a properly secured system will have a different MySQL
        # username and password, and if so, you'll need to
        # change these settings.
  :database => "rss2mysql")

class Items <  ActiveRecord::Base
end

# If the table doesn't exist, we'll create it.

unless Items.table_exists?
  ActiveRecord::Schema.define do
    create_table :items do |t|
        t.column :title, :string
        t.column :content, :string
        t.column :source, :string
        t.column :url, :string
        t.column :timestamp, :timestamp
        t.column :keyword_id, :integer
        t.column :guid, :string
      end
  end
end


feed=FeedTools::Feed.open(feed_url)

feed.items.each do |feed_item|
  if not (Items.find_by_title(feed_item.title)
          or Items.find_by_url(feed_item.link)
          or Items.find_by_guid(feed_item.guid))
  puts "processing item '#{feed_item.title}' - new"
    Items.new do |newitem|

      newitem.title=feed_item.title.gsub(/<[^>]*>/, '')
      newitem.guid=feed_item.guid
      if feed_item.publisher.name
          newitem.source=feed_item.publisher.name
      end

      newitem.url=feed_item.link
      newitem.content=feed_item.description
      newitem.timestamp=feed_item.published

      newitem.save
    end
  else
    puts "processing item '#{feed_item.title}' - old"

  end
end


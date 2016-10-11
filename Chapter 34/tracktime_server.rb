#!/usr/bin/ruby

%w(rubygems camping ).each { |lib| require lib }

# Populate our namespace with Camping functionality.
Camping.goes :TrackTime

#
# Contains the application's single model, ClientTime.
#
module TrackTime::Models
  #Sets or retrieves the schema.
  def self.schema(&block)
    @@schema = block if block_given?
    @@schema
  end


  #
  # The single model for this application.
  # It inherits from ActiveRecord,
  # so you can use it like any Rails
  # model.
  #
  class ClientTime < Base

    # Returns the difference between the starting
    # and stopping times - if the entry hasn't been
    # stopped yet, it will return the time elapsed
    # since it was started.
    def elapsed
      diff=((stop || Time.now) - start)
      format("%0.2f",(diff/3600))
    end
  end
end

#
# Sets the schema, defining our single table.
#
TrackTime::Models.schema do
  create_table :tracktime_client_times, :force => true do |t|
    t.column :client, :string, :limit => 255
    t.column :start, :datetime
    t.column :stop, :datetime
    t.column :created_at, :datetime
  end
end

#
# Get ready to run by creating the database
# if it doesn't already exist.
#
def TrackTime.create
 unless TrackTime::Models::ClientTime.table_exists?
   ActiveRecord::Schema.define(&TrackTime::Models.schema)
   TrackTime::Models::ClientTime.reset_column_information
 end
end

#
# Contains all of the controllers for the application.
#
module TrackTime::Controllers

  #
  # Homepage for the application.
  #
  class Index < R '/'
    def get

      @times=ClientTime.find_all
      render :homepage
    end
  end

  #
  # Controller which creates a new timer.
  #
  class Start < R('/start/')
    def get
      @text='Started!'
      new_time=ClientTime.create :client=>@input[:client], :start=>Time.now
      render :statictext
    end
  end

  #
  # Controller for stopping a timer.
  #
  class Stop < R('/stop/(\w+)')
    def get(id)
      @text='Stopped!'
      old_time=ClientTime.find id

      if !old_time
        @text="failed on stopping time # #{id}"
      else
        old_time.update_attributes :stop=>Time.now
      end

      render :statictext
    end
  end

  #
  # Deletes a timer.
  #
  class Kill < R('/kill/(\w+)')
    def get(id)
      @text='Killed!'

      deleted_successfully=ClientTime.delete id

      @text="failed on killing time # #{id}" unless deleted_successfully

      render :statictext
    end
  end

end

#
# Contains all of the views for the application.
#

module TrackTime::Views
  TIME_FORMAT="%H:%M:%S"

  #
  # View which statically shows a message with a
  # redirect back to the homepage.
  #
  def statictext
    h1 { a @text, :href=>R(Index), :style=>’text-align:center’}
  end

  #
  # View which shows the homepage.
  #
  def homepage
    div do

      table :cellpadding=>5, :cellspacing=>0  do
        tr do
          th :colspan=>6 do
            form :action=> R(Start) do
              p  do
                strong 'start timer: '
                br
                label 'client name'
                input :name=>'client', :type=>'text', :size=>'5'
                input :type=>'submit', :value=>'start'
              end
            end
          end
        end
        tr do
          th 'Client'
          th 'Start'
          th 'Stop'
          th 'Elapsed'
        end
        (@times || []).each do |time|
          tr :style =>"background-color: #{(time.stop ? 'white' : '#FFEEEE')}" do
            td time.client
            td time.start.strftime(TIME_FORMAT)

            if time.stop
              td time.stop.strftime(TIME_FORMAT)
            else
              td {a 'Stop now', :href=>R(Stop,time.id) }
            end
            unless !time.start

              td "#{time.elapsed} hrs"
            end

            td {a 'kill', :href=>R(Kill, time.id)}
          end
        end

      end
    end
  end

  #
  # Layout which controls the appearance
  # of all other views.
  #
  def layout
    html do
      head do
        title 'TrackTime'
      end
      body do
        h1 "welcome to tracktime"
        div.content do
          self << yield
        end
      end
    end
  end

end


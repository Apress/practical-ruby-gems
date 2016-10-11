# Include hook code here
require 'ajax_scaffold_plugin'

ActionController::Base.send(:include, AjaxScaffold)
ActionView::Base.send(:include, AjaxScaffold::Helper)

# copy all the files over to the main rails app, want to avoid .svn
source = File.join(directory,'/app/views/ajax_scaffold')
dest = File.join(RAILS_ROOT, '/app/views/ajax_scaffold')
FileUtils.mkdir(dest) unless File.exist?(dest)
FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)

source = File.join(directory,'/public')
dest = RAILS_ROOT + '/public'
FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)

source = File.join(directory,'/public/stylesheets')
dest = RAILS_ROOT + '/public/stylesheets'
FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)

source = File.join(directory,'/public/javascripts')
dest = RAILS_ROOT + '/public/javascripts'
FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)

source = File.join(directory,'/public/images')
dest = RAILS_ROOT + '/public/images'
FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)
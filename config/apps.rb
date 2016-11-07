##
# This file mounts each app in the Padrino project to a specified sub-uri.
# You can mount additional applications using any of these commands below:
#
#   Padrino.mount('blog').to('/blog')
#   Padrino.mount('blog', :app_class => 'BlogApp').to('/blog')
#   Padrino.mount('blog', :app_file =>  'path/to/blog/app.rb').to('/blog')
#
# You can also map apps to a specified host:
#
#   Padrino.mount('Admin').host('admin.example.org')
#   Padrino.mount('WebSite').host(/.*\.?example.org/)
#   Padrino.mount('Foo').to('/foo').host('bar.example.org')
#
# Note 1: Mounted apps (by default) should be placed into the project root at '/app_name'.
# Note 2: If you use the host matching remember to respect the order of the rules.
#
# By default, this file mounts the primary app which was generated with this project.
# However, the mounted app can be modified as needed:
#
#   Padrino.mount('AppName', :app_file => 'path/to/file', :app_class => 'BlogApp').to('/')
#

##
# Setup global project settings for your apps. These settings are inherited by every subapp. You can
# override these settings in the subapps as needed.
#
Padrino.configure_apps do
  # enable :sessions
  set :session_secret, 'be76dd2f6cd12ece10545d1bb0cbf9dc64deef57cdc97a9c7fde5123125c2007'
  set :protection, :except => :path_traversal
  set :protect_from_csrf, true
end

# Mounts the core application for this project

Padrino.mount('FbotWeb::Gamedev', :app_file => Padrino.root('gamedev/app.rb')).to('/gamedev')

Padrino.mount('FbotWeb::Rsn', :app_file => Padrino.root('rsn/app.rb')).to('/rsn')

Padrino.mount('FbotWeb::Sqlru', :app_file => Padrino.root('sqlru/app.rb')).to('/sqlru')

Padrino.mount('FbotWeb::Lor', :app_file => Padrino.root('lor/app.rb')).to('/lor')

Padrino.mount('FbotWeb::Onln', :app_file => Padrino.root('onln/app.rb')).to('/onln')

Padrino.mount('FbotWeb::Fpda', :app_file => Padrino.root('fpda/app.rb')).to('/fpda')
Padrino.mount('FbotWeb::App', :app_file => Padrino.root('app/app.rb')).to('/')

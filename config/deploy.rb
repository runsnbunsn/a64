require "bundler/capistrano"
require File.expand_path '../deploy_helpers/helper_functions.rb', __FILE__
# SETUP SECTION =================================================

load_target_server

set :scm, "git"
set :repository, "git://github.com/iboard/#{source_repository}.git"
set :branch, "master"
# END SETUP SECTION =============================================


load "config/recipes/base"
load "config/recipes/check"

# LOAD RECIPES FOR A WEBRICK-SERVER WITH APACHE PROXY-BALANCER
load "config/recipes/virtual_host_proxy_balancer"
load "config/recipes/webrick"
load "config/recipes/paperclip"
load "config/recipes/application_config"
load "config/recipes/documentation"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do

  after  "deploy:update_code", "deploy:assets:precompile"

  namespace :assets do
    task :precompile do
      if File::exist?(File.expand_path('../precompile_assets.txt',__FILE__))
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=production assets:precompile}
      else
        puts %{
          WARNING

          deploy:assets:precompile skipped because there is no file
          config/precompile_assets.txt

          If you like assets being precompiled at deploy please
          touch config/precompile_assets.txt and check this file in
          with git add config/precompile_assets.txt

          Precompiling assets on the debian server takes very long.
          This ensures it will not be run unless it will be necessary.
        }
      end
    end
    before "deploy:assets:precompile", "bundle:install"
  end
end

after "deploy", "deploy:cleanup" # keep 5 versions only


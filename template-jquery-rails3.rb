# Rails 3.0.1

@after_blocks = []
def after_bundler(&block); @after_blocks << block; end
def say_wizard(text); say "\033[36m" + "wizard".rjust(10) + "\033[0m" + "    #{text}" end

# include gems
gem 'slim'
gem 'slim-rails'
gem 'formtastic', '~> 1.1.0'
gem 'rails3-generators'
gem 'devise'
gem 'pg'

gem 'factory_girl_rails', :group=>[:development, :test]
gem 'rspec-rails', '>= 2.0.1', :group=>[:development, :test]
gem 'cucumber-rails', :group=>[:development, :test]
gem 'cucumber', :group=>[:development, :test]
gem 'database_cleaner', :group=>[:development, :test]
gem 'spork', :group=>[:development, :test]
gem 'capybara', :group=>[:development, :test]
gem 'ruby-debug19', :group=>[:development, :test]

# create rspec.rb in the config/initializers directory to use rspec as the default test framework
# initializer 'rspec.rb', <<-EOF
#   Rails.application.config.generators.test_framework :rspec
# EOF
if yes?('Usa proxy? (yes/no): ')
  proxy="http_proxy=$http_proxy"
end
  
inside "public/javascripts" do
  run "#{(proxy.empty? ? '' : proxy)} curl http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js > jquery.js"
  run "#{(proxy.empty? ? '' : proxy)} curl http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js > jquery-ui.js"
  run "#{(proxy.empty? ? '' : proxy)} curl http://github.com/rails/jquery-ujs/raw/master/src/rails.js > rails.js"
end
# get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js", "public/javascripts/jquery.js"
# get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
# get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', '# config.action_view.javascript_expansions[:defaults] = %w(jquery rails)', '# config.action_view.javascript_expansions[:defaults] = %w(jquery jquery-ui rails)'

# run formtastic, devise, cucumber and rspec generators
after_bundler do
  generate 'formtastic:install'
  generate 'cucumber:install --rspec --capybara'
  generate 'rspec:install'
  generate 'devise:install'
  generate 'devise user'
end
# commit template results to repo
# git :commit => '-a -m "Criação da app via Template"'

# Criando Layout
layout = <<-LAYOUT
! doctype html
html
  head
    title Sistema
    meta name="keywords" content="template language"
    == formtastic_stylesheet_link_tag
    == javascript_include_tag(:defaults)
    == csrf_meta_tag

  body
    == yield
LAYOUT

# remove Prototype defaults
run "rm public/javascripts/controls.js"
run "rm public/javascripts/dragdrop.js"
run "rm public/javascripts/effects.js"
run "rm public/javascripts/prototype.js"

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.slim", layout


say_wizard "Bundler install demora um tempinho, vá tomar um cafezinho ou uma água..."
run 'bundle install'
# say_wizard "Running after Bundler callbacks."
@after_blocks.each{|b| b.call}
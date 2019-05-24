source 'https://gems.ruby-china.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use pg as the database for Active Record
gem 'pg', '0.21.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  #调试工具
  gem "thin"
  # gem "factory_girl_rails", "~> 4.0"
  gem "factory_bot"
  gem "pry-rails", "~> 0.3.2"
  gem 'pry-doc'
  gem 'pry-byebug', "~> 2.0.0"
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


#接口权限验证
gem "pundit"

# Build JSON APIs with ease.
gem 'active_model_serializers', '= 0.10.4'

# Use jwt
gem 'jwt', '= 1.3.0'

# Use kaminari for pagination
gem 'kaminari', '1.0.1'

#查询
gem 'ransack'

#图片上传
gem "paperclip", "5.1.0"

#微信支付
gem 'wx_pay'

#支付宝支付
gem 'alipay', '~> 0.15.0'

gem 'rest-client'

gem 'mqtt', :git => 'https://github.com/njh/ruby-mqtt.git'
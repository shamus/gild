ENV["RAILS_ENV"] ||= 'test'
$LOAD_PATH << File.join(File.dirname(__FILE__), '../')

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Gild::TemplateHelpers
end

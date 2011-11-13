module Gild
  class Railtie < Rails::Railtie
    initializer "gild.initialize" do |app|
      ActiveSupport.on_load(:action_view) { require 'gild/initializers/rails_3.rb' }
    end
  end
end

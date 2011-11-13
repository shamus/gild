# Rails 3.X Template
module ActionView
  module Template::Handlers
    class GildHandler
      class_attribute :default_format
      self.default_format = Mime::JSON

      def self.call(template)
        source = template.source.empty? ? File.read(template.identifier) : template.source

       <<-CODE 
         Gild::Template.new(#{source.inspect}).render(self, assigns.merge(local_assigns))
       CODE
      end
    end
  end
end

ActionView::Template.register_template_handler :gild, ActionView::Template::Handlers::GildHandler

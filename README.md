# Gild #

    class LinkBuilder < Gild::Builder
      helper  Rails.application.routes.url_helpers
      helper SomeOtherHelper

      template do
        object @link, :attributes => [:id, :url, :status] do
          attribute(:created_at) { |created_at| created_at.to_s(:custom_format) }

          object :resources do
            virtual(:show_path) { |link| link_path(link) }
          end

          object @link.submitter, :as => :submitted_by do
            attributes [:sidereel_id, :sidereel_type]
          end
        end
      end

      array @alternate_links, :attributes => [:id, :url, :status]
    end

    LinkBuilder.render("@link" => link, "@alternate_links" =>
    alternate_links).to_hash

Which would yield:

    {
      link => {
        'id' => 1,
        'url' => "http://www.example.com/1",
        'status' => "processed",
        'created_at' => "November 5, 2011",

        'resources' => { 'show_path' => 'links/1' },
        'submitted_by' => { 'sidereel_id' => 1, 'sidereel_type' => "Admin" }
      }

      links => [
        { "id" => 2, "url" => "http://www.example.com/2", "status" =>
    processed" },
        { "id" => 3, "url" => "http://www.example.com/3", "status" =>
    processed" },
        { "id" => 4, "url" => "http://www.example.com/4", "status" =>
    processed" }
      ]
    }

The DSL also supports rendering other Builders (essentiall you'd call
'render SomeOtherBuilder'). The render call can be called from
anywhere.  It just starts dumping its output at the level you called
it at.

Its three small classes.  Next up would be rails support and some
configuration (like don't render null values).

# frozen_string_literal: true

require 'rails/generators'

class StimulusGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  desc 'Creates a Stimulus controller with automatic registration'

  def create_controller_file
    # Create the controller file
    controller_path = "app/javascript/controllers/#{file_name}_controller.js"

    create_file controller_path, <<~JAVASCRIPT
      import { Controller } from "@hotwired/stimulus"

      // Connects to data-controller="#{file_name.tr('_', '-')}"
      export default class extends Controller {
        static targets = []
        static values = {}
      #{'  '}
        connect() {
          console.log("#{class_name} controller connected!")
        }
      #{'  '}
        // Add your methods here
      }
    JAVASCRIPT

    # Register the controller
    register_controller
  end

  def show_usage
    if behavior == :invoke
      say "\n✅ Stimulus controller created and registered!", :green
      say "\n📝 Usage in views:\n", :cyan
      say "  <div data-controller=\"#{file_name.tr('_', '-')}\">"
      say '    <!-- your content -->'
      say "  </div>\n"
      say "\n🔄 Just refresh your browser!", :yellow
    else
      say "\n✅ Stimulus controller '#{file_name.tr('_', '-')}' destroyed!", :green
      say '   Import and registration automatically removed', :green
      say "🔄 Refresh your browser to see changes.\n", :yellow
    end
  end

  private

  def register_controller
    stimulus_file = 'app/javascript/stimulus.js'
    return unless File.exist?(stimulus_file)

    content = File.read(stimulus_file)

    import_line = "import #{class_name}Controller from \"controllers/#{file_name}_controller\""
    register_line = "application.register(\"#{file_name.tr('_', '-')}\", #{class_name}Controller)"

    if behavior == :revoke
      # DESTROY: Remove the lines
      content.gsub!(%r{^import #{class_name}Controller from "controllers/#{file_name}_controller"\n}, '')
      content.gsub!(/^application\.register\("#{Regexp.escape(file_name.tr('_', '-'))}", #{class_name}Controller\)\n/,
                    '')
      File.write(stimulus_file, content)
      say '  ✅ Removed from stimulus.js', :green
    else
      # GENERATE: Add the lines
      return if content.include?(import_line)

      # Find the imports section
      last_import = content.rindex(/^import.*Controller from/)

      if last_import
        line_end = content.index("\n", last_import)
        content = "#{content[0..line_end]}\n#{import_line}#{content[line_end + 1..]}"
      end

      # Find the register section
      last_register = content.rindex(/^application\.register\(/)

      if last_register
        line_end = content.index("\n", last_register)
        content = "#{content[0..line_end]}\n#{register_line}#{content[line_end + 1..]}"
      end

      File.write(stimulus_file, content)
      say '  ✅ Added to stimulus.js', :green
    end
  end
end

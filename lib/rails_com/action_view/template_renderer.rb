# frozen_string_literal: true

module RailsCom

  module TemplateRenderer

    # record where the view rendered from, main project or which engine
    # used by view helper methods: js_load, css_load, js_ready
    def render_template(view, template, layout_name, locals)
      path = template.identifier

      result = path.match(/(?<=\/)[a-zA-Z0-9_-]+(?=\/app\/views)/)
      result = result.to_s.split('-').first.to_s + '/engine'
      engine = result.classify.safe_constantize
      
      view.instance_variable_set(:@_rendered_engine, engine.root) if engine
      view.instance_variable_set(:@_rendered_path, template.virtual_path) if template.respond_to? :virtual_path
      
      super
    end

  end

  module PartialRenderer

    def find_template(path, locals)
      if path.start_with?('_')
        prefixes = @lookup_context.prefixes
      elsif path.include?(?/)
        prefixes = []
      else
        prefixes = @lookup_context.prefixes
      end
      @lookup_context.find_template(path, prefixes, true, locals, @details)
    end

  end

end

ActiveSupport.on_load :action_view do
  ActionView::TemplateRenderer.prepend RailsCom::TemplateRenderer
  ActionView::PartialRenderer.prepend RailsCom::PartialRenderer
end

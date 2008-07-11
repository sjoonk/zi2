# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def display_tree_recursive(tree, parent_id)
    ret = "\n<ul id=\"category\">"
    tree.each do |node|
      if node.parent_id == parent_id
        ret += "\n\t<li>"
        ret += yield node
        ret += display_tree_recursive(tree, node.id) { |n| yield n } unless node.children.empty?
        ret += "\t</li>\n"
      end
    end
    ret += "</ul>\n"
  end

	def display_breadcrumbs(categories)
		categories.collect { |category| yield category }.join(' > ')
	end

	def expand_tree_into_select_field(categories, current_id = nil)
	  returning(String.new) do |html|
	    categories.each do |category|
	      html << %{<option value="#{ category.id }">#{ '&nbsp;&nbsp;&nbsp;' * category.ancestors.size }#{ category.name }</option>}
	      html << expand_tree_into_select_field(category.children) if category.has_children?
	    end
	  end
	end

	def javascript_onload(function=nil)
		# generated javascript function sample: mycontrollers.initAction();
		function ||= "#{controller.controller_name}.init#{controller.action_name.capitalize}"
		#function = function.to_s
		content_for(:javascript) do
			%Q(window.onload = #{function.to_s};)
		end
	end
	
	def include_stylesheet(*sources)
		content_for(:stylesheet) do
			stylesheet_link_tag(*sources)
		end
	end
	
	def include_javascript(*sources)
		content_for(:javascript) do
			javascript_include_tag(*sources)
		end
	end
	
	def jquery_onload(&block)
		content_for(:jquery_onload) do
			javascript_tag "$(document).ready(function() { #{capture(&block)} });"
		end
	end
  
end

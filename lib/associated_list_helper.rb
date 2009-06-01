
module AssociatedListHelper

  def associated_list(object_name, method_name, html_options = {})
    association = association(object_name, method_name)
    container_id = "#{object_name}_#{association.name}_container"    
    
    list_items = ''
    current_targets = record(object_name).send(association.name)
    current_targets.each do |target|
      list_items += association_list_item(object_name, association.name, target.to_label, target.id)
    end
    
    list = content_tag('ul', list_items, :class => 'associations_list', :id => container_id)
    hidden_input = tag('input', :type => 'hidden', :name => "#{object_name}[#{association.name.to_s.singularize}_ids][]", :value => "")
    list_container = content_tag('div', hidden_input + list, :class => 'associations_list_container')
    
    options = content_tag('option', "Select #{association.class_name.titleize}...", :selected => 'true')
    available_targets = association.class_name.constantize.find(:all)
    available_targets.delete_if {|element| current_targets.include? element }
    options += options_from_collection_for_select(available_targets, :id, :to_label)

    insertion_text = association_list_item(object_name, association.name, "' + this.options[this.selectedIndex].text + '", "' + this.options[this.selectedIndex].value + '", true)
    select = content_tag('select', options, 
      :id => "record_add_to_#{association.name.to_s}", 
      :name => "record_add_to_#{association.name.to_s}",
      :onchange => "if (this.selectedIndex > 0) { new Insertion.Bottom('#{container_id}', '#{insertion_text}'); this.options[this.selectedIndex] = null; }"
      )
    
    list_modifier = content_tag('div', select, :class => 'association_list_modifier')

    wrapper = content_tag('div', list_container + list_modifier, {:class => 'associations_list_wrapper'}.merge(html_options))

    wrapper + tag('br', :style => 'clear: both')
  end

protected

  def association_list_item(object_name, association_name, display_name, id, quote = false)
    container_id = "#{object_name}_#{association_name}_container"
    item_id = "association#{id}#{object_name}#{association_name}"
    
    hidden_input = tag('input', :type => 'hidden', :name => "#{object_name}[#{association_name.to_s.singularize}_ids][]", :value => "$ID$")
    delete_link = link_to('&times;', '#', 
      :onclick => "Element.remove(this.parentNode); var sel = $('record_add_to_#{association_name}'); sel.options[sel.options.length] = new Option(\'$DisplayName$\', \'$ID$\');")      
    item = content_tag('li', delete_link + " $DisplayName$" + hidden_input, :id => item_id, :class => 'association')
    
    item = escape_javascript(item) if quote
    item.gsub!('$DisplayName$', display_name)
    item.gsub!('$ID$', id.to_s)
    item
  end

  def record(object_name)
    self.instance_variable_get ("@#{object_name}")
  end

  def association(object_name, method_name)
    record(object_name).class.reflect_on_association(method_name.to_sym)
  end

  def association_label(column)
    column.name[0..-4].to_sym
  end

  def column(object_name, method)
    record(object_name).column_for_attribute(method)
  end
  
end

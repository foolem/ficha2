class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    class_attr_index = html_tag.index 'class="'

    if class_attr_index
      html_tag.insert class_attr_index+7, 'error '
    else
      html_tag.insert html_tag.index('>'), ' class="error"'
    end
  end

end

# http://guides.rubyonrails.org/active_record_validations.html

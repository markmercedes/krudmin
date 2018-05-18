module DocsHelper
  def render_menu_item_for(doc_file, label = nil)
    content_tag :a, class: "list-group-item list-group-item-action #{active_class_for(doc_file)}", href: doc_url_for(doc_file) do
      label || doc_file.split("/").last.humanize.html_safe
    end
  end

  def doc_url_for(doc_file)
    "/#{doc_file}"
  end

  def current_doc_displayed?(doc_file)
    active_doc_file == doc_file
  end

  def active_class_for(doc_file)
    "active" if current_doc_displayed?(doc_file)
  end
end

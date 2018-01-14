module Features
  def have_header(title)
    have_css("h4", text: title)
  end

  def have_label(title)
    have_css("label", text: title)
  end

  def have_table_header(title)
    have_css("th", text: title)
  end

  def row_css_for(model)
    "tr.item-model-#{model.id}"
  end

  def click_activation_link_for(model)
    within(row_css_for(model)) do
      all(".btn-activate-item").first.click
    end
  end

  def click_deactivation_link_for(model)
    within(row_css_for(model)) do
      all(".btn-deactivate-item").first.click
    end
  end

  def click_destroy_link_for(model)
    within(row_css_for(model)) do
      all(".btn-destroy-item").first.click
    end
  end

  def click_edit_link_for(model)
    within(row_css_for(model)) do
      all(".btn-edit-item").first.click
    end
  end

  def click_show_link_for(model)
    within(row_css_for(model)) do
      all(".btn-show-item").first.click
    end
  end
end

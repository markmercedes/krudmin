module PageFeatures
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

  def click_add_link
    within('.card-header') do
      click_link("Add")
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

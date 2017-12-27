module Krudmin::ActivableLabeler
  def active__label
    active ? label_for_active(I18n.t('krudmin.labels.active')) : label_for_inactive(I18n.t('krudmin.labels.inactive'))
  end

  protected

  def label_for_active(value)
    Arbre::Context.new { span(class: "badge badge-success") { value } }
  end

  def label_for_inactive(value)
    Arbre::Context.new { span(class: "badge badge-danger") { value } }
  end
end

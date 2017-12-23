module Krudmin::ActivableLabeler
  def active__label
    active ? label_for_active : label_for_inactive
  end

  private

  def label_for_active
    Arbre::Context.new { span(class: "badge badge-success") { I18n.t('krudmin.labels.active') } }
  end

  def label_for_inactive
    Arbre::Context.new { span(class: "badge badge-danger") { I18n.t('krudmin.labels.inactive') } }
  end
end

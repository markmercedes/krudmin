module Krudmin::LabelizedMethods
  def method_missing(method, *args, &block)
    label_method = method.to_s.gsub("__label", '').to_sym

    return send(label_method) if methods.include?(label_method)
    super
  end
end

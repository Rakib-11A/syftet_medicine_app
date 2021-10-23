module Admin::PrintBarcodesHelper
  def attribute_present?(params, attr)
    params[attr].present?
  end

  def attribute_true?(params, attr)
    attribute_present?(params, attr) ? params[attr] == "1" : false
  end

  def set_style_value(params, attr)
    attribute_present?(params, attr) ? params[attr] + 'px' : '0px'
  end
end

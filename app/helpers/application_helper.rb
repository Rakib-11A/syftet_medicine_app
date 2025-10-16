# frozen_string_literal: true

module ApplicationHelper
  # Devise Things

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def format_date(date = Date.today)
    I18n.localize(date, format: :long) if date.present?
  end

  def format_datetime_short(date = Date.today)
    date.strftime('%d-%m-%Y') if date.present?
  end

  def get_date(date)
    date.strftime('%A, %d %B %Y')
  end

  def format_datetime_long(date = Time.now)
    date.strftime('%d-%m-%Y %I:%M %p') if date.present?
  end

  # Menu things

  def get_active_class(action, menu_action)
    action == menu_action ? 'active' : ''
  end

  def generate_breadscrumb(text, taxon = nil, product = nil, customs = {})
    html_code = ''
    if taxon.present?
      html_code += taxon_breadscrumb(taxon.category) # + "<li> #{link_to taxon.name, ''} </li>"
    end
    html_code += "<li> #{link_to taxon.name, ''} </li>" if product.present?
    customs.each do |link_text, link|
      html_code += "<li> #{link_to link_text, link} </li>"
    end
    html_code + "<li> #{t(text.downcase.to_sym)} </li>"
  end

  def sort_link(_object, _field, text)
    text
  end

  def taxon_breadscrumb(node)
    html = []
    return '' unless node.present?

    html.push("<li> #{link_to node.name, categories_path(node.permalink)} </li>")
    html.push(taxon_breadscrumb(node.category)) if node.category.present?
    html.reverse.join('')
  end

  def currency_symbol
    @settings.currency_symbol
  end

  def color_filters(taxon = nil)
    variants = filter_variant(taxon)
    variants.collect { |vr| vr.color if vr.color.present? }.compact
  end

  def size_filters(taxon = nil)
    variants = filter_variant(taxon)
    variants.collect { |vr| vr.size if vr.size.present? }.compact
  end

  def filter_variant(taxon)
    if taxon
      product_ids = taxon.products.map(&:id)
      Product.where(product_id: product_ids)
    else
      Product.all.limit(10)
    end
  end

  def link_to_tracking(shipment, target)
    link_to shipment.tracking, "/shipment/tracking/#{shipment.tracking}", { target: target }
  end

  def payment_method(type)
    payment_method = PaymentMethod.find_by_type(type)
    if payment_method.present?
      payment_method.id
    else
      0
    end
  end

  def map_text_to_icon(text)
    case text
    when 'paypalexpress'
      'paypal'
    when 'cash'
      'money'
    when 'creditpoint'
      'bullseye'
    else
      text
    end
  end

  def included_tax_total(order)
    order.tax_total.positive? ? amount_with_currency(order.tax_total) : 'All Taxes Included'
  end

  def pretty_time(time)
    [I18n.l(time.to_date, format: :long), time.strftime('%l:%M %p')].join(' ')
    # time.strftime("%l:%M %p")
  end
end

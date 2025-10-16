# frozen_string_literal: true

class AppSettings
  USER_TYPE = {
    customer: 'Customer',
    retailers: 'Retailers'
  }.freeze

  PER_PAGE_FILTER = {
    4 => '4 products per page',
    15 => '15 products per page',
    25 => '25 products per page',
    35 => '35 products per page',
    45 => '45 products per page'
  }.freeze

  PRODUCT_TYPE_FILTER = {
    recent: 'Latest Products',
    sale: 'Sale Products',
    featured: 'Featured Products',
    top_rate: 'Top Rated',
    '' => 'All Product'
  }.freeze

  PRODUCT_SORTING = {
    date: 'Default sorting',
    price_low: 'Price: low to high',
    price_high: 'Price: high to low',
    rating: 'By rating'
  }.freeze
end

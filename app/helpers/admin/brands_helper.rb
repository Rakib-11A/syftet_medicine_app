# frozen_string_literal: true

module Admin
  module BrandsHelper
    def get_brand_url(link)
      "#{root_url}b/#{link}"
    end
  end
end

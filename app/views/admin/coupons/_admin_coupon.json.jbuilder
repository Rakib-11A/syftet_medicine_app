json.extract! admin_coupon, :id, :code, :name, :discount, :percentage, :expiration, :maximun_limit, :created_at, :updated_at
json.url admin_coupon_url(admin_coupon, format: :json)

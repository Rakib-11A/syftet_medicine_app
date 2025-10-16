# frozen_string_literal: true

module UserReporting
  def lifetime_value
    orders.complete.sum(:total)
  end

  def order_count
    orders.complete.size
  end

  def average_order_value
    if order_count.to_i.positive?
      lifetime_value / order_count
    else
      BigDecimal('0.00')
    end
  end
end

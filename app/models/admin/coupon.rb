class Admin::Coupon < ApplicationRecord
  self.table_name = 'admin_coupons'
  validates :maximun_limit, :expiration, presence: true
  validates :code, presence: true, length:  { minimum: 5, maximum: 50 }, uniqueness: { case_sensitive: false }
  # validates_presence_of :discount, :if => lambda { self.percentage.blank? }
  has_many :order
end

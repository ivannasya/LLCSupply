class Load < ActiveRecord::Base
  has_many :orders
  accepts_nested_attributes_for :orders

  scope :morning, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'M') }
  scope :noon, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'N') }
  scope :evening, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'E') }
end
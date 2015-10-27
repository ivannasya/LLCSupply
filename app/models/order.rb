class Order < ActiveRecord::Base
  include ImportFromCsv

  belongs_to :origin, class_name: "Point", foreign_key: "origin_id" 
  belongs_to :destination, class_name: "Point", foreign_key: "destination_id"
  belongs_to :origin_stop, class_name: "Stop", foreign_key: "origin_stop_id"
  belongs_to :destination_stop, class_name: "Stop", foreign_key: "destination_stop_id"
  belongs_to :load
  
  SHIFT = [:M, :E, :N]
  MODE = [:TRUCKLOAD]
  HANDLING_UNIT_TYPE = [:box]
  
  symbolize :shift, in: SHIFT, allow_blank: true
  symbolize :mode, in: MODE, allow_blank: true
  symbolize :handling_unit_type, in: HANDLING_UNIT_TYPE, allow_blank: true

  scope :all_by_date, ->(orders_date) { where("delivery_date = ? or delivery_date IS NULL", orders_date || Order::DEFAULT_DATE) }
  
  DEFAULT_DATE = '2014-09-15'
  
  def self.uniq_dates
    self.pluck(:delivery_date).uniq.compact.sort_by {|time| time}
  end

  def description
    [self.volume, self.handling_unit_quantity, self.handling_unit_type].compact.join(", ")
  end

  def self.orders_validation(orders)
    validation_errors = {}
    orders.each do |order|
      validator = OrderValidator.new(order.attributes)
      validator.valid?
      validation_errors["#{validator.id}"] = validator.errors.full_messages
    end
    validation_errors
  end
end

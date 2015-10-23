class Order < ActiveRecord::Base
  include ImportFromCsv

  belongs_to :origin, class_name: "Point", foreign_key: "origin_id" 
  belongs_to :destination, class_name: "Point", foreign_key: "destination_id"
  belongs_to :origin_stop, class_name: "Stop", foreign_key: "origin_stop_id"
  belongs_to :destination_stop, class_name: "Stop", foreign_key: "destination_stop_id"
  belongs_to :load

  accepts_nested_attributes_for :origin_stop
  accepts_nested_attributes_for :destination_stop
  
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
    "#{self.volume}/#{self.handling_unit_quantity}/#{self.handling_unit_type}"
  end

end

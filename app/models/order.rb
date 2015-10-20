class Order < ActiveRecord::Base
  include ImportFromCsv
  include UpdateOrderAssociation

  belongs_to :origin, class_name: "Point", foreign_key: "origin_id" 
  belongs_to :destination, class_name: "Point", foreign_key: "destination_id"
  belongs_to :load

  SHIFT = [:M, :E, :N]
  MODE = [:TRUCKLOAD]
  HANDLING_UNIT_TYPE = [:box]
  
  symbolize :shift, in: SHIFT, allow_blank: true
  symbolize :mode, in: MODE, allow_blank: true
  symbolize :handling_unit_type, in: HANDLING_UNIT_TYPE, allow_blank: true

  scope :uniq_dates, -> { pluck(:delivery_date).uniq.compact }

  DEFAULT_DATE = '2014-09-15'
end

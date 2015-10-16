class Order < ActiveRecord::Base
  include ImportFromCsv
  include UpdateOrderAssociation

  belongs_to :origin, class_name: "Point", foreign_key: "origin_id" 
  belongs_to :destination, class_name: "Point", foreign_key: "destination_id"

  symbolize :shift, in: [:M, :E, :N]
  symbolize :mode, in: [:TRUCKLOAD]
  symbolize :handling_unit_type, in: [:box]
end

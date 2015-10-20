class Point < ActiveRecord::Base
  has_many :origin_orders, class_name: "Order", foreign_key: "origin_id" 
  has_many :destination_orders, class_name: "Order", foreign_key: "destination_id"

  scope :find_by_attrs, ->(zip, name, raw_line_1, city, state, country) { where("zip = :zip and name = :name and raw_line_1 = :raw_line_1 and city = :city and state = :state and country = :country", 
  		  zip: zip, name: name, raw_line_1: raw_line_1, city: city, state: state, country: country) }
end
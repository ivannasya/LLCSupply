class Stop < ActiveRecord::Base
  has_many :origin_orders, class_name: "Order", foreign_key: "origin_stop_id" 
  has_many :destination_orders, class_name: "Order", foreign_key: "destination_stop_id"
  belongs_to :point
  belongs_to :load

  scope :find_by_attrs, ->(number, point_id, load_id) { where("number = :number and point_id = :point_id and load_id = :load_id", 
        number: number, point_id: point_id, load_id: load_id) }

  def orders_count
    self.origin_orders.count + self.destination_orders.count
  end
end

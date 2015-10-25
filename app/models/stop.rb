class Stop < ActiveRecord::Base
  has_many :origin_orders, class_name: "Order", foreign_key: "origin_stop_id" 
  has_many :destination_orders, class_name: "Order", foreign_key: "destination_stop_id"
  belongs_to :point
  belongs_to :load

  validates :point_id, :number, presence: true
  validate do
    check_orders_sequence
  end

  scope :find_by_attrs, ->(number, load_id) { where("number = :number and load_id = :load_id", 
        number: number, load_id: load_id) }

  def orders_count
    self.origin_orders.count + self.destination_orders.count
  end

  private

  def orders_sequence_valid?
    orders_valid = []
    self.origin_orders.each {|order| orders_valid << (order.origin_id == self.point_id) }
    self.destination_orders.each {|order| orders_valid << (order.destination_id == self.point_id) }
    orders_valid.all?
  end

  def check_orders_sequence
    errors.add(:orders, "has wrong sequenceers") unless orders_sequence_valid?
  end
end

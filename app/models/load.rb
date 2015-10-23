class Load < ActiveRecord::Base
  has_many :stops, -> { order 'stops.number' }
  has_many :orders
  accepts_nested_attributes_for :stops
  accepts_nested_attributes_for :orders

  scope :morning, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'M') }
  scope :noon, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'N') }
  scope :evening, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'E') }

  def to_csv
    CSV.generate(col_sep: ";") do |csv|
      csv << ['Order of stop', 'Address', 'Type', 'Purchase order', 'Description of cargo', 'Contact phone']
      self.stops.each do |stop|
        stop_attr = [stop.number, Point.find(stop.point_id).address]
        stop.destination_orders.each do |order|
          order_attr = ['Unload', order.order_number, order.description, order.phone_number]
          csv << stop_attr + order_attr
        end
        stop.origin_orders.each do |order|
          order_attr = ['Load', order.order_number, order.description, order.phone_number]
          csv << stop_attr + order_attr
        end
      end
    end
  end
end
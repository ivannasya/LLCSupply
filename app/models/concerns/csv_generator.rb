class CsvGenerator
  
  def self.generate(load)
    CSV.generate(col_sep: ";") do |csv|
      csv << ['Order of stop', 'Address', 'Date and shift', 'Type', 'Purchase order', 'Description (volume, quantity, type)', 'Contact phone']
      load.stops.each do |stop|
        stop_attr = [stop.number, Point.find(stop.point_id).address, "#{load.date}, #{load.shift}"]
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
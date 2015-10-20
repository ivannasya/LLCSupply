class OrderValidator
  include ActiveModel::Validations  
  
  attr_accessor :id, :delivery_date, :shift, :origin_id, :destination_id, :phone_number, :mode, :order_number, :volume, :handling_unit_quantity, :handling_unit_type, :load_id,
  				:origin_name, :origin_raw_line_1, :origin_city, :origin_state, :origin_zip, :origin_country, 
				:destination_name, :destination_raw_line_1, :destination_city, :destination_state, :destination_zip, :destination_country

  validates :delivery_date, :origin_id, :destination_id, :phone_number, :mode, :order_number, :volume, :handling_unit_quantity, :handling_unit_type,
  			:origin_name, :origin_raw_line_1, :origin_city, :origin_state, :origin_zip, :origin_country, 
  			:destination_name, :destination_raw_line_1, :destination_city, :destination_state, :destination_zip, :destination_country, 
  			presence: true

  validates :mode, inclusion: { in: Order::MODE.map(&:to_s) }
  validates :handling_unit_type, inclusion: { in: Order::HANDLING_UNIT_TYPE.map(&:to_s) }
  validates_numericality_of :order_number, :origin_zip, :destination_zip,  only_integer: true
  validates :order_number, length: { is: 9 }

  def initialize(order = {})  
    order.each do |name, value|  
      send("#{name}=", value)  
    end
    initialize_association(@destination_id, 'origin')
    initialize_association(@destination_id, 'destination')
  end

  def initialize_association(id, kind)
    unless id.nil?
      Point.find(id).attributes.except("id").each do |name, value|  
        send("#{kind}_#{name}=", value)
      end
  	end
  end  

  def self.phone_number_format
    /\A(\d{1}-)?(\(\d{3}\)|\d{3}[-.])\d{3}[-.]\d{4}( x\d{3,5})?\z/i
  end

  validates_format_of :phone_number, with: phone_number_format
end
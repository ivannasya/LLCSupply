class LoadForm
  include ActiveModel::Model

  attr_accessor :date, :shift, :validation_errors

  validates :date, :shift, presence: true

  def persisted?
  	false
  end

  def initialize(orders)  
  	@orders = orders
  	validation
  end

  def validation
  	@validation_errors = {}
  	@orders_valid = []
  	@orders.each do |order|
  	  validator = OrderValidator.new(order.attributes)
  	  valid = validator.valid?
  	  @orders_valid << valid
  	  @validation_errors["#{validator.id}"] = validator.errors.full_messages
  	end
  end

  def submit(params)
    return false unless @orders_valid.all?
    self.date = params[:date]
    Load.transaction do
      create_load("M", params[:orders])
      create_load("N", params[:orders])
      create_load("E", params[:orders])
    end
  end

  def create_load(shift, params)
  	@orders_update_valid = []
  	load = Load.new({date: date, shift: shift})
  	return false unless load.valid?
	params.each do |order_id, value|
  	  if value[:shift] == shift
  	  	order = Order.find(order_id)
  	  	order.create_loads = true
  	  	@orders_update_valid << order.valid?
		@validation_errors["#{order_id}"] = order.errors.full_messages unless order.valid?
  	  	order.update_attributes(destination_number: value[:destination_number], 
  	  							origin_number: value[:origin_number])
  	  	load.orders << order
  	  end
  	end
  	return false unless @orders_update_valid.all? 
  	load.save
  end
end
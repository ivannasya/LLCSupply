class LoadForm
  include ActiveModel::Model

  attr_accessor :date, :shift, :validation_errors

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

  def orders_valid?
  	@orders.each do |order|
  	  validator = OrderValidator.new(order.attributes)
  	  validator.valid?
  	end
  end

  def submit(params)
    return false unless @orders_valid.all?
    self.date = params[:date]
    # p times_origin = params[:times_origin]
    # p times_destination = params[:times_destination]
    load_orders = params[:order_ids].zip(params[:shifts]).to_h
    Load.transaction do
      create_load("M", load_orders)
      create_load("N", load_orders)
      create_load("E", load_orders)
    end
  end

  def create_load(shift, load_orders)
  	load = Load.new({ date: date, shift: "#{shift}" })
  	load.order_ids=(load_orders.select{ |o_id, s| s == "#{shift}" }).keys
  	load.save
  end
end
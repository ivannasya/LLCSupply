class LoadForm
  include ActiveModel::Model

  attr_accessor :date, :shift, :validation_errors, :stops, :shifts, :delviery_date

  validates :date, :shift, presence: true

  def stops_attributes=(attributes)
    @stops ||= []
    attributes.each do |i, stop_params|
      @stops.push(Stop.new(stop_params))
    end
  end

  def persisted?
    false
  end

  def initialize(orders) 
    @orders = orders
    validation
  end

  def date
    @date || []
  end

  def date=(date)
    @date = date
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
    shifts = params[:shifts].values.uniq.reject(&:empty?)
    return false unless @orders_valid.all?
    self.date = params[:date]
    Load.transaction do
      shifts.each {|shift| create(shift, params)}
    end
  end

  def create(shift, params)
    load = Load.new({date: date, shift: shift})
    return false unless load.valid?
    stops_params = get_stops_by_shifts(params)["#{shift}"]
    stops_params = stops_params.group_by {|s| s[:number]}
    stops_params.each do |number, s_p|
      stop = load.stops.build(number: number, point_id: s_p.first[:point_id])
      s_p.each do |s| 
        order_name = s.keys.last.to_s 
        order = Order.find(s["#{order_name}"])
        stop.send("#{order_name}s") << order
        load.orders << order
      end
    end
    load.save
  end

  def update(load, params)
    params[:orders_attributes].each do |i, order_params|
      order = Order.find(order_params[:id])
      update_stop('origin', order_params[:origin_stop_attributes], order, load)
      update_stop('destination', order_params[:destination_stop_attributes], order, load)
    end
  end

  def update_stop(kind, params, order, load)
    association = order.send("#{kind}_stop")
    stop = Stop.find_by_attrs(params[:number], params[:point_id], load.id).first
    if stop.nil?
      stop = order.send("create_#{kind}_stop", params.except("id"))
      load.stops << stop
    else
      stop = order.send("#{kind}_stop=", stop)
    end
    order.save
    load.save
    association.delete if association.orders_count == 0
  end

  def get_stops_by_shifts(params)
    params[:stops_attributes].values.group_by{|s| params[:shifts]["#{s[:origin_order]}"] ||
                                                  params[:shifts]["#{s[:destination_order]}"]}
  end
end
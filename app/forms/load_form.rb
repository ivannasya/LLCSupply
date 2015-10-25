class LoadForm
  include ActiveModel::Model

  attr_accessor :date, :shift, :validation_errors, :stops, :shifts, :delviery_date

  validates :date, :shift, presence: true

  def persisted?
    false
  end

  def initialize(orders) 
    @orders = orders
    validation
  end

  def stops_attributes=(attributes)
    @stops ||= []
    attributes.each do |i, stop_params|
      @stops.push(Stop.new(stop_params))
    end
  end

  def stops
    @stops || []
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
    shifts.each {|shift| return false unless create(shift, params)}
    delete_old_loads(params[:date])
    true
  end

  def create(shift, params)
    load = Load.new({date: date, shift: shift})
    load.get_driver
    stops_params = get_stops_by_shifts(params)["#{shift}"]
    stops_params = stops_params.group_by {|s| s[:number]}
    stops_params.each {|number, stop| create_stop(number, stop, load, shift)}
    unless load.valid?
      @validation_errors["#{shift}"] = load.errors.full_messages
      return false
    end
    load.save
  end

  def create_stop(number, params, load, shift)
    stop = load.stops.build(number: number, point_id: params.first[:point_id])
    params.each do |s| 
      order_name = s.keys.last.to_s 
      order = Order.find(s["#{order_name}"])
      stop.send("#{order_name}") << order
      unless stop.valid?
        @validation_errors["#{shift}"] = stop.errors.full_messages
        return false
      end
      load.orders << order
    end
  end

  def get_stops_by_shifts(params)
    params[:stops_attributes].values.group_by{|s| params[:shifts]["#{s[:origin_orders]}"] ||
                                                  params[:shifts]["#{s[:destination_orders]}"]}
  end

  def delete_old_loads(date)
    loads = Load.where("date = ?", date)
    loads.each {|load| load.delete if load.orders.empty?}
  end
end
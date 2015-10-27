class Load < ActiveRecord::Base
  has_many :stops, -> { order 'stops.number' }, dependent: :destroy
  has_many :orders
  belongs_to :user
  accepts_nested_attributes_for :stops
  accepts_nested_attributes_for :orders

  validates :date, :shift, :driver_id, presence: true

  scope :morning, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'M') }
  scope :noon, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'N') }
  scope :evening, ->(orders_date) { where("date = ? and shift = ?", orders_date || Order::DEFAULT_DATE, 'E') }

  VOLUME = 1400

  validate do
    check_orders_volume
  end

  def to_csv
    CsvGenerator.generate(self)
  end

  def get_driver
    counter = (self.date - Order::DEFAULT_DATE.to_date).to_i
    if counter.odd? 
      first  = User.where("role = ?", 'driver_two').first.id
      second = User.where("role = ?", 'driver_one').first.id
    else
      first  = User.where("role = ?", 'driver_one').first.id
      second = User.where("role = ?", 'driver_two').first.id
    end
    case self.shift
    when 'M' then self.driver_id = first
    when 'N' then self.driver_id = second
    when 'E' then self.driver_id = first
    else nil
    end
  end

  private

  def orders_volume_valid?
    check = []
    volume = 0
    self.stops.each do |stop| 
      stop.origin_orders.each {|order| volume += order.volume} 
      stop.destination_orders.each {|order| volume -= order.volume}
      check << (volume.round(2) <= 1400)
    end
    check.all?
  end

  def check_orders_volume
    errors.add(:orders, "volume is larger than allowed(should be less then #{Load::VOLUME})") unless orders_volume_valid?
  end
end
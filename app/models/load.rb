class Load < ActiveRecord::Base
  has_many :stops, -> { order 'stops.number' }, dependent: :destroy
  has_many :orders, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :stops

  validates :date, :shift, :driver_id, presence: true

  symbolize :shift, :in => [:M, :N, :E], scopes: true

  scope :morning, ->(orders_date) { where("date = ? and shift = ?", orders_date, 'M') }
  scope :noon, ->(orders_date) { where("date = ? and shift = ?", orders_date, 'N') }
  scope :evening, ->(orders_date) { where("date = ? and shift = ?", orders_date, 'E') }

  VOLUME = 1400

  validate do
    check_orders_volume
  end

  def to_csv
    CsvGenerator.generate(self)
  end

  private

  def orders_volume_valid?
    check = []
    volume = 0
    stops.each do |stop|
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

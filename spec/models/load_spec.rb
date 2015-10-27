require 'rails_helper'
require 'concerns/csv_generator'
require 'csv'

RSpec.describe Load, type: :model do 
  
  describe "exporting a load to_csv" do
    before do 
      @point = create(:point)
      @load = create(:load) do |load|
        load.stops.create(attributes_for(:stop, point_id: @point.id)) do |stop|
          stop.origin_orders.build(attributes_for(:order, origin_id: @point.id))
          stop.destination_orders.build(attributes_for(:order, destination_id: @point.id))
        end
      end
      @origin_orders = @load.stops.first.origin_orders
      @destination_orders = @load.stops.first.destination_orders
    end

    subject { @load.to_csv }

    ['Order of stop', 'Address', 'Date and shift', 'Type', 'Purchase order', 'Description (volume, quantity, type)', 'Contact phone'].each do |title|
      it { should include title }
    end

    it { should include @load.stops.first[:number].to_s }
    it { should include @point.address }
    it { should include "#{@load.date}, #{@load.shift}" }
    it { should include "Load" }
    it { should include @origin_orders.first[:order_number] }
    it { should include @origin_orders.first.description }
    it { should include @origin_orders.first[:phone_number] }
    it { should include @destination_orders.first[:order_number] }
    it { should include @destination_orders.first.description }
    it { should include @destination_orders.first[:phone_number] }
  end

  it '#get driver by shift M, date 2015-09-15' do
    driver_one = create(:user, username: 'driver_one', password: 'driver_one', role: 'driver_one')
    driver_two = create(:user, username: 'driver_two', password: 'driver_two', role: 'driver_two')
    load = build(:load, driver_id: nil)
    load.get_driver
    expect(load.driver_id).to eq(driver_two.id)
  end

  it '#get driver by shift N, date 2015-09-15' do
    driver_one = create(:user, username: 'driver_one', password: 'driver_one', role: 'driver_one')
    driver_two = create(:user, username: 'driver_two', password: 'driver_two', role: 'driver_two')
    load = build(:load, shift: 'N', driver_id: nil)
    load.get_driver
    expect(load.driver_id).to eq(driver_one.id)
  end

  it '#get driver by shift E, date 2015-09-15' do
    driver_one = create(:user, username: 'driver_one', password: 'driver_one', role: 'driver_one')
    driver_two = create(:user, username: 'driver_two', password: 'driver_two', role: 'driver_two')
    load = build(:load, shift: 'E', driver_id: nil)
    load.get_driver
    expect(load.driver_id).to eq(driver_two.id)
  end

  it '#get driver by shift M, date 2015-09-16' do
    driver_one = create(:user, username: 'driver_one', password: 'driver_one', role: 'driver_one')
    driver_two = create(:user, username: 'driver_two', password: 'driver_two', role: 'driver_two')
    load = build(:load, date: '2015-09-16', driver_id: nil)
    load.get_driver
    expect(load.driver_id).to eq(driver_one.id)
  end

  it '#get driver by shift N, date 2015-09-16' do
    driver_one = create(:user, username: 'driver_one', password: 'driver_one', role: 'driver_one')
    driver_two = create(:user, username: 'driver_two', password: 'driver_two', role: 'driver_two')
    load = build(:load, date: '2015-09-16', shift: 'N', driver_id: nil)
    load.get_driver
    expect(load.driver_id).to eq(driver_two.id)
  end

  it '#get driver by shift E, date 2015-09-16' do
    driver_one = create(:user, username: 'driver_one', password: 'driver_one', role: 'driver_one')
    driver_two = create(:user, username: 'driver_two', password: 'driver_two', role: 'driver_two')
    load = build(:load, date: '2015-09-16', shift: 'E', driver_id: nil)
    load.get_driver
    expect(load.driver_id).to eq(driver_one.id)
  end

  it "validates that valid volume of load less or equal #{Load::VOLUME}" do
    point = create(:point) 
    load = build(:load) 
    stop = load.stops.build(attributes_for(:stop, point_id: point.id))
    stop.origin_orders.build(attributes_for(:order, origin_id: point.id, volume: Load::VOLUME-300))
    stop.origin_orders.build(attributes_for(:order, origin_id: point.id, volume: 300))
    load.valid?
    expect(load.errors.messages).to eq({})
  end

  it "validates that invalid volume of load less or equal #{Load::VOLUME}" do
    point = create(:point) 
    load = build(:load) 
    stop = load.stops.build(attributes_for(:stop, point_id: point.id))
    stop.origin_orders.build(attributes_for(:order, origin_id: point.id, volume: Load::VOLUME))
    stop.origin_orders.build(attributes_for(:order, origin_id: point.id, volume: 1))
    load.valid?
    expect(load.errors.messages[:orders]).to eq(["volume is larger than allowed(should be less then #{Load::VOLUME})"])
  end
end
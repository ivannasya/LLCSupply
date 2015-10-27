require 'rails_helper'

RSpec.describe Stop, type: :model do 
    
  it 'validates that valid has right sequenceers' do
    point_one = create(:point) 
    point_two = create(:point) 
    load = build(:load) 
    stop = load.stops.build(attributes_for(:stop, point_id: point_one.id))
    stop.origin_orders.build(attributes_for(:order, origin_id: point_one.id, destination_id: point_two.id))
    stop.origin_orders.build(attributes_for(:order, origin_id: point_one.id, destination_id: point_two.id))
    stop.destination_orders.build(attributes_for(:order, origin_id: point_two.id, destination_id: point_one.id))
    stop.destination_orders.build(attributes_for(:order, origin_id: point_two.id, destination_id: point_one.id))
    load.valid?
    expect(load.errors.messages).to eq({})
  end

  it 'validates that valid has origin wrong sequenceers' do
    point_one = create(:point) 
    point_two = create(:point) 
    load = build(:load) 
    stop = load.stops.build(attributes_for(:stop, point_id: point_one.id))
    stop.origin_orders.build(attributes_for(:order, origin_id: point_two.id, destination_id: point_one.id))
    stop.destination_orders.build(attributes_for(:order, origin_id: point_two.id, destination_id: point_one.id))
    stop.destination_orders.build(attributes_for(:order, origin_id: point_two.id, destination_id: point_one.id))
    load.valid?
    expect(load.errors.messages[:"stops.orders"]).to eq(["has wrong sequenceers"])
  end

  it 'validates that valid has destination wrong sequenceers' do
    point_one = create(:point) 
    point_two = create(:point) 
    load = build(:load) 
    stop = load.stops.build(attributes_for(:stop, point_id: point_one.id))
    stop.origin_orders.build(attributes_for(:order, origin_id: point_one.id, destination_id: point_two.id))
    stop.destination_orders.build(attributes_for(:order, origin_id: point_one.id, destination_id: point_two.id))
    load.valid?
    expect(load.errors.messages[:"stops.orders"]).to eq(["has wrong sequenceers"])
  end
end
require 'rails_helper'
require 'order_validator.rb'

RSpec.describe Stop, type: :model do 
  let(:order) { create(:order) }
  let(:huge_order) { create(:order, volume: Load::VOLUME+1) }
  let(:order_number) { create(:order, order_number: 1234567890) }
  let(:order_type) { build(:order, handling_unit_type: 'not_box') }
  let(:order_mode) { build(:order, mode: 'not_TRUCKLOAD') }
  let(:order_phone) { build(:order, phone_number: '8(846)4545') }

  it "validates that volume is valid" do
    huge_order.valid?
    expect(huge_order.errors.messages).to eq({})
  end

  it "validates that volume less then #{Load::VOLUME}" do
    validator = OrderValidator.new(huge_order.attributes)
    validator.valid?
    expect(validator.errors.messages[:volume]).to eq(["must be less than or equal to #{Load::VOLUME}"])
  end

  it "validates that order_number is valid" do
    validator = OrderValidator.new(order.attributes)
    validator.valid?
    expect(huge_order.errors.messages).to eq({})
  end

  it "validates that order_number has length 9" do
    validator = OrderValidator.new(order_number.attributes)
    validator.valid?
    expect(validator.errors.messages[:order_number]).to eq(["is the wrong length (should be 9 characters)"])
  end

  it "validates that handling_unit_type is box" do
    validator = OrderValidator.new(order_type.attributes)
    validator.valid?
    expect(validator.errors.messages[:handling_unit_type]).to eq(["is not included in the list"])
  end

  it "validates that mode is TRUCKLOAD" do
    validator = OrderValidator.new(order_mode.attributes)
    validator.valid?
    expect(validator.errors.messages[:mode]).to eq(["is not included in the list"])
  end

  it "validates that phone_number is invalid" do
    validator = OrderValidator.new(order_phone.attributes)
    validator.valid?
    expect(validator.errors.messages[:phone_number]).to eq(["is invalid"])
  end
end
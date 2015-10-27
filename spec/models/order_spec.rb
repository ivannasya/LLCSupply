require 'rails_helper'
require 'validations/order_validator'

RSpec.describe Stop, type: :model do 
  let(:order) { create(:order) }
  let(:huge_order) { create(:order, volume: Load::VOLUME+1) }

  it "validates that volume less then #{Load::VOLUME}" do
    huge_order.valid?
    expect(huge_order.errors.messages).to eq({})
  end

  it "validates that volume less then #{Load::VOLUME}" do
    huge_order.valid?
    expect(huge_order.errors.messages).to eq({})
  end


end
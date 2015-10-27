require 'rails_helper'

RSpec.describe User, type: :model do 
  it 'as dispatcher' do
    dispatcher = create(:dispatcher, username: 'dispatcher', password: 'dispatcher', role: 'dispatcher')
    expect(dispatcher.dispatcher?).to eq(true)
  end

  it 'as not dispatcher' do
    driver = create(:user, username: 'driver', password: 'driver', role: 'driver_one')
    expect(driver.dispatcher?).to eq(false)
  end
end
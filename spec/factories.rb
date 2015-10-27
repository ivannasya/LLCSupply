FactoryGirl.define do

  factory :user do
    sequence(:username) {|n| "name#{n}"}
    password "password"
    role "driver_one"

    factory :dispatcher do 
      username 'dispatcher'
      password 'dispatcher'
      role 'dispatcher'
    end
  end

  factory :load do
    date '2015-09-15'
    shift 'M'
    driver_id '2'
  end

  factory :order do
    delivery_date '2015-09-15'
    shift 'M'
    phone_number '131.601.7742 x29127'
    mode 'TRUCKLOAD'
    order_number '500398675'
    volume 60
    handling_unit_quantity 4
    handling_unit_type 'box'
    association :origin, factory: :point
    association :destination, factory: :point, name: 'Destination point'
    association :origin_stop, factory: :stop
    association :destination_stop, factory: :stop
    load
  end

  factory :point do 
    name 'Origin point'
    raw_line_1 'Lenina'
    city 'SAMARA'
    state 'SM'
    zip 11111
    country 'RF'
  end

  factory :stop do
    number 1
    point
    load
  end
end
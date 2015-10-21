class Load < ActiveRecord::Base
  has_many :orders
  accepts_nested_attributes_for :orders
end
class User < ActiveRecord::Base
  has_secure_password
  has_many :loads

  validates_uniqueness_of :username

  def dispatcher?
    self.role == 'dispatcher'
  end
end

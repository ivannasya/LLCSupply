class User < ActiveRecord::Base
  has_secure_password
  has_many :loads, foreign_key: :driver_id

  validates :username, :password, presence: true
  validates_uniqueness_of :username

  def dispatcher?
    role == 'dispatcher'
  end
end

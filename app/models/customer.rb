class Customer < ActiveRecord::Base
  has_many :orders

  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true
end

class Customer < ActiveRecord::Base
  has_one :order

  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true
end

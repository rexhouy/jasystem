class Door < ActiveRecord::Base
  belongs_to :order

  validates :count, presence: true
end
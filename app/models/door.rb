class Door < ActiveRecord::Base
  belongs_to :order

  validates :count, presence: true

  def finished?
    status.eql? 1
  end

  def delayed?
    order.delivery_date < Date.today
  end


end

class BathroomDoor < Door; end

class Order < ActiveRecord::Base
  belongs_to :customer, dependent: :destroy
  has_many :doors, dependent: :destroy

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :doors

  validates :delivery_date, presence: true
  validates :order_date, presence: true
  validates_associated :customer
  validates_associated :doors

  scope :customer, lambda { |value| joins(:customer).where(customers: {:name => value}) }
  scope :type, lambda { |value| joins(:doors).where(doors: { :type => value }) }
  scope :status, lambda { |value| where(:status => value) }
  scope :order_date, lambda { |value| where(:order_date => value) }
  scope :delivery_date, lambda { |value| where(:delivery_date => value) }

  def self.filter(attributes)
    supported_filters = [:customer, :type, :order_date, :delivery_date, :status]
    attributes.slice(*supported_filters).inject(self) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

  def updateCascade(attributes, update_doors)
    # find and remove
    new_doors_id = update_doors.map { |door|
      door[1][:id]
    }
    find_destroied_doors(doors, new_doors_id).each { |door|
      door.destroy
    }
    update(attributes)
  end

private
    def find_destroied_doors(doors, new_doors_id)
    doors.select { |door|
      !new_doors_id.include? door.id.to_s
    }
  end


end

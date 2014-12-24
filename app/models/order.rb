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
  scope :order_date, lambda { |value| where(:order_date => value) }
  scope :delivery_date, lambda { |value| where(:delivery_date => value) }

  def self.filter(attributes)
    supported_filters = [:customer, :type, :order_date, :delivery_date]
    attributes.slice(*supported_filters).inject(self) do |scope, (key, value)|
      value.present? ? scope.send(key, value) : scope
    end
  end

end

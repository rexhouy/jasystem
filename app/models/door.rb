class Door < ActiveRecord::Base
        belongs_to :order

        validates :count, presence: true

        CONFIG = YAML.load_file(Rails.root.join("config/drawing.yml"))

        def finished?
                status.eql? 1
        end

        def delayed?
                order.delivery_date < Date.today
        end

        def drawing_data
                conf = CONFIG[material.to_f]
                return {} if conf.nil?
                data = Hash[conf.map { |key, value|
                                    [key, compute(size_x, size_y, sill, value)]
                            }]
                data["size_x"] = size_x
                data["size_y"] = size_y
                data["count"] = count
                data["sill"] = sill
                data["material"] = material
                data["order_date"] = order.order_date
                data["delivery_date"] = order.delivery_date
                data["name"] = order.customer.name
                data
        end

        private
        def compute(x, y, sill, value)
                eval value.to_s
        end

end

class BathroomDoor < Door; end

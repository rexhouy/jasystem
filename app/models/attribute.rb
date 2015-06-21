class Attribute < ActiveRecord::Base
        has_many :children, :foreign_key => :parent, :class_name => :Attribute
end

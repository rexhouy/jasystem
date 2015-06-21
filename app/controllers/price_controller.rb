class PriceController < ApplicationController

        def index
                attrs = Attribute.all
                @category_groups = group_by_category(attrs)
        end

        private
        def group_by_category(attrs)
                groups = {}
                attrs.each do |attr|
                        groups[attr.category] ||= {}
                        groups[attr.category][attr.kind] ||= []
                        groups[attr.category][attr.kind] << attr
                end
                groups
        end

end

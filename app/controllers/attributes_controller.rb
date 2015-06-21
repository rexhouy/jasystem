class AttributesController < ApplicationController
        before_action :set_attribute, only: [:edit, :update, :destroy]

        respond_to :html

        def index
                if params[:category].nil?
                        @attributes = Attribute.all
                else
                        @attributes = Attribute.where(category: params[:category])
                end
                respond_with(@attributes)
        end

        def new
                @attribute = Attribute.new
                @parents = []
                respond_with(@attribute)
        end

        def edit
                @parents = Attribute.where(kind: @attribute.kind, parent: nil)
        end

        def create
                @attribute = Attribute.new(attribute_params)
                @attribute.save
                redirect_to :attributes
        end

        def update
                @attribute.update(attribute_params)
                redirect_to :attributes
        end

        def destroy
                @attribute.destroy
                respond_with(@attribute)
        end

        private
        def set_attribute
                @attribute = Attribute.find(params[:id])
        end

        def attribute_params
                params.require(:attribute).permit(:kind, :name, :price, :category)
        end
end

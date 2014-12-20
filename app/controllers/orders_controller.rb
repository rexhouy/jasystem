class OrdersController < ApplicationController

  def index
    @customer = params[:customer] || ""
    @type = params[:type] || ""
    @order_date = params[:order_date] || ""
    @delivery_date = params[:delivery_date] || ""

    @orders = Order.filter(params).distinct.paginate(:page => params[:page])
    puts @orders.inspect
  end

  def new
    @order = Order.new
    @order.customer ||= Customer.new
    @order.doors.build
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order
    else
      render :action => "new"
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_path
  end

  private
  def order_params
    params.require(:order).permit(:order_date, :delivery_date,
                                  customer_attributes: [:name, :address, :phone],
                                  doors_attributes: [:sill, :count, :size_x, :size_y, :material])
  end

end

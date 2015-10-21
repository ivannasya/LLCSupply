class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.import_from_csv(params[:file])
    redirect_to orders_url
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      @order.update_association('origin', association_params('origin'))
      @order.update_association('destination', association_params('destination'))
      redirect_to @order
    else
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_url
  end

  def destroy_all
    Order.destroy_all
    redirect_to orders_url
  end

  private

    def order_params
      params.require(:order).permit(:delivery_date, :shift, :origin_id, :destination_id, :phone_number, :mode, :order_number, :volume, :handling_unit_quantity, :handling_unit_type)
    end

    def association_params(kind)
      params.require(:order).permit("#{kind}" => [:zip, :name, :raw_line_1, :city, :state, :country])["#{kind}"]
    end
end

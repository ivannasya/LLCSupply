class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders = Order.includes(:origin, :destination).all
  end

  def show
  end

  def edit
  end

  def create
    @order = Order.import_from_csv(params[:file])
    respond_to do |format|
      format.html { redirect_to orders_url}
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        @order.update_association('origin', association_params('origin'))
        @order.update_association('destination', association_params('destination'))
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
    end
  end

  def destroy_all
    Order.destroy_all
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Orders was successfully destroyed.' }
    end
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:delivery_date, :shift, :origin_id, :destination_id, :phone_number, :mode, :order_number, :volume, :handling_unit_quantity, :handling_unit_type)
    end

    def association_params(kind)
      params.require(:order).permit("#{kind}" => [:name, :raw_line_1, :city, :state, :zip, :country])["#{kind}"]
    end
end

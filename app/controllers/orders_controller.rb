class OrdersController < ApplicationController

  def index
    @orders = Order.all
  end

  def create
    @order = Order.import_from_csv(params[:file])
    redirect_to orders_url
  end

  def show
    @order = Order.find(params[:id])
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order_form = OrderForm.new(@order)
    if @order_form.update(params)
      redirect_to @order
    else
      @validation_errors = @order_form.validation_errors
      render :edit
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to(:back)
  end

  def destroy_all
    Order.destroy_all
    redirect_to orders_url
  end
end
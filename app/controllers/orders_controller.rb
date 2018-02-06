class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def index
    @orders_date = Order.uniq_dates
    @orders = Order.preload(:origin, :destination).all_by_date(params[:orders_date])
    @validation_errors = Order.orders_validation(@orders)
  end

  def create
    @order = Order.import_from_csv(params[:file])
    redirect_to orders_url
  end

  def show
  end

  def edit
  end

  def update
    @order_form = OrderForm.new(@order)
    if @order_form.update(params)
      redirect_to @order
    else
      @validation_errors = @order_form.validation_errors
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to(:back)
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end

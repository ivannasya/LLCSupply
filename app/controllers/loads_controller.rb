class LoadsController < ApplicationController
  def new
  	@orders_date = Order.uniq_dates
  	@orders = Order.includes(:origin, :destination).where("delivery_date = ? or delivery_date IS NULL", params[:orders_date] || Order::DEFAULT_DATE)
  	@form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
  end

  def create
    @orders_date = Order.uniq_dates
    @orders = Order.includes(:origin, :destination).where("delivery_date = ? or delivery_date IS NULL", params[:orders_date] || Order::DEFAULT_DATE)
  	@form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
    if @form.submit(params[:load_form])
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @orders_date = Order.uniq_dates
    @loadM = Load.where("date = ? and shift = ?", params[:orders_date] || Order::DEFAULT_DATE, 'M')
    @loadN = Load.where("date = ? and shift = ?", params[:orders_date] || Order::DEFAULT_DATE, 'N')
    @loadE = Load.where("date = ? and shift = ?", params[:orders_date] || Order::DEFAULT_DATE, 'E')
  end

  def show
    @load = Load.find(params[:id])
  end
end

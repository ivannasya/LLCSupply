class LoadsController < ApplicationController
  
  def index
    @orders_date = Order.uniq_dates
    @loadM = Load.morning(params[:orders_date])
    @loadN = Load.noon(params[:orders_date])
    @loadE = Load.evening(params[:orders_date])
  end

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
      redirect_to loads_path
    else
      render 'new'
    end
  end

  def show
    @orders = []
    @load = Load.find(params[:id])
    @load.orders.each do |order|
      @orders << order_params(order, 'origin')
      @orders << order_params(order, 'destination')
    end
    @orders.sort_by! { |hsh| hsh[:number] }
  end

  def edit
    @load = Load.find(params[:id])
    @orders = @load.orders
  end

  def update
    @load = Load.find(params[:id])
    if @load.update_attributes(load_params)
      redirect_to @load
    else
      render :edit
    end
  end

  def destroy
    @load = Load.find(params[:id])
    @load.destroy
    redirect_to loads_path
  end

  private

  def load_params
    params.require(:load).permit(orders_attributes: [:id, :origin_number, :destination_number])
  end

  def order_params(order, kind)
    kind == 'origin' ? type = 'Load' : type = 'Unload'
    { number: order.send("#{kind}_number"), 
      address: order.send("#{kind}").name + ', ' + 
               order.send("#{kind}").raw_line_1 + ', ' + 
               order.send("#{kind}").city + ', ' + 
               order.send("#{kind}").state + ', ' + 
               order.send("#{kind}").country + ', ' + 
               order.send("#{kind}").zip,
      order_number: order.order_number,
      description:  "#{order.volume}/#{order.handling_unit_quantity}/#{order.handling_unit_type}",
      phone_number: order.phone_number,
      type: type
    }
  end
end

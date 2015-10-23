class LoadsController < ApplicationController
  
  def index
    @orders_date = Order.uniq_dates
    @loadM = Load.morning(params[:orders_date])
    @loadN = Load.noon(params[:orders_date])
    @loadE = Load.evening(params[:orders_date])
  end

  def new
    @orders_date = Order.uniq_dates
    @orders = Order.all_by_date(params[:orders_date])
    @form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
  end

  def create
    @orders_date = Order.uniq_dates
    @orders = Order.all_by_date(params[:orders_date])
    @form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
    if @form.submit(params[:load_form])
      redirect_to loads_path
    else
      render 'new'
    end
  end

  def show
    @load = Load.find(params[:id])
    respond_to do |format|
      format.html
      format.csv { send_data @load.to_csv, filename: "#{@load.date}-#{@load.shift}.csv" }
    end
  end

  def edit
    @load = Load.find(params[:id])
    @orders = @load.orders
  end

  def update
    @load = Load.find(params[:id])
    @orders = @load.orders
    @load_form = LoadForm.new(@orders)
    if @load_form.update(@load, load_params)
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
    params.require(:load).permit(orders_attributes: [:id, origin_stop_attributes: [:id, :number, :point_id], destination_stop_attributes: [:id, :number, :point_id] ])
  end

  def load_form_params
    params.require(:load_form).permit(:date, stops_attributes: [:id, :number, :point_id, :origin_orders])
  end

end
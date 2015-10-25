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
    @orders = Order.all_by_date(params[:load_form][:date])
    @form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
    if @form.submit(params[:load_form])
      redirect_to loads_path
    else
      render 'edit'
    end
  end

  def show
    @load = current_resourse
    respond_to do |format|
      format.html
      format.csv { send_data @load.to_csv, filename: "#{@load.date}-#{@load.shift}.csv" }
    end
  end

  def edit
    @orders = Order.all_by_date(current_resourse.date)
    @form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
  end

  def destroy
    @load = current_resourse
    @load.orders.clear
    @load.destroy
    redirect_to loads_path
  end

  private

  def current_resourse
    @current_resourse ||= Load.find(params[:id]) if params[:id]
  end

  def load_params
    params.require(:load).permit(orders_attributes: [:id, origin_stop_attributes: [:id, :number, :point_id], destination_stop_attributes: [:id, :number, :point_id] ])
  end

  def load_form_params
    params.require(:load_form).permit(:date, stops_attributes: [:id, :number, :point_id, :origin_orders])
  end

end
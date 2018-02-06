class LoadsController < ApplicationController
  before_action :set_orders_date, only: [:index, :new]
  before_action :set_load, only: [:show, :edit, :destroy]

  def index
    @loads = if current_user.dispatcher?
      params[:orders_date].present? ? Load.where("date = ?", params[:orders_date]) : Load.all
    else
      params[:orders_date].present? ? current_user.loads.where("date = ?", params[:orders_date]) : current_user.loads
    end
  end

  def new
    init_load_form(params[:orders_date])
  end

  def create
    init_load_form(params[:load_form][:date])
    if @form.submit(params[:load_form])
      redirect_to loads_path(orders_date: params[:load_form][:date])
    else
      render 'edit'
    end
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_data @load.to_csv, filename: "#{@load.date}-#{@load.shift_text}.csv" }
    end
  end

  def edit
    init_load_form(@load.date)
  end

  def destroy
    @load.destroy
    redirect_to loads_path
  end

  def destroy_all
    Load.destroy_all
    redirect_to orders_url
  end

  private

  def init_load_form(date)
    @orders = Order.all_by_date(date)
    @form = LoadForm.new(@orders)
    @validation_errors = @form.validation_errors
  end

  def set_orders_date
    @orders_date ||= Order.uniq_dates
  end

  def set_load
    @load = Load.find(params[:id])
  end

  def load_params
    params.require(:load).permit(orders_attributes: [:id, origin_stop_attributes: [:id, :number, :point_id], destination_stop_attributes: [:id, :number, :point_id] ])
  end

  def load_form_params
    params.require(:load_form).permit(:date, stops_attributes: [:id, :number, :point_id, :origin_orders])
  end
end

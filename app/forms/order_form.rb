class OrderForm
  include ActiveModel::Model

  attr_accessor :delivery_date, :shift, :origin_id, :destination_id, :phone_number, :mode, :order_number, :volume, :handling_unit_quantity, :handling_unit_type, :validation_errors

  def initialize(order)
    @order = order
  end

  def update(params)
    @validation_errors = {}
    @order.update(order_params(params))
    update_association('origin', association_params('origin', params))
    update_association('destination', association_params('destination', params))
    validator = OrderValidator.new(@order.attributes)
    validator.valid?
    @validation_errors["#{validator.id}"] = validator.errors.full_messages
    return false unless validator.valid?
    @order.save
  end

  def update_association(kind, params)
    association = @order.send("#{kind}")
    @order.create_association(kind, params)
    association.delete if association.send("#{kind}_orders").count == 0
  end

  def order_params(params)
    params.require(:order).permit(:delivery_date, :shift, :origin_id, :destination_id, :phone_number, :mode, :order_number, :volume, :handling_unit_quantity, :handling_unit_type)
  end

  def association_params(kind, params)
    params.require(:order).permit("#{kind}" => [:zip, :name, :raw_line_1, :city, :state, :country])["#{kind}"]
  end

end
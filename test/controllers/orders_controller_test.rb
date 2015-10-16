require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { shift: @order.shift, delivery_date: @order.delivery_date, destination: @order.destination, handling_unit_quantity: @order.handling_unit_quantity, handling_unit_type: @order.handling_unit_type, mode: @order.mode, order_number: @order.order_number, origin: @order.origin, phone_number: @order.phone_number, volume: @order.volume }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { shift: @order.shift, delivery_date: @order.delivery_date, destination: @order.destination, handling_unit_quantity: @order.handling_unit_quantity, handling_unit_type: @order.handling_unit_type, mode: @order.mode, order_number: @order.order_number, origin: @order.origin, phone_number: @order.phone_number, volume: @order.volume }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end

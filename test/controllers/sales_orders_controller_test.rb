require 'test_helper'

class SalesOrdersControllerTest < ActionController::TestCase
  setup do
    @sales_order = sales_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_order" do
    assert_difference('SalesOrder.count') do
      post :create, sales_order: { contact_user_id: @sales_order.contact_user_id, created_at: @sales_order.created_at, created_by_id: @sales_order.created_by_id, customer_user_id: @sales_order.customer_user_id, grand_total: @sales_order.grand_total, name: @sales_order.name, subtotal: @sales_order.subtotal, tax: @sales_order.tax, updated_at: @sales_order.updated_at, updated_by_id: @sales_order.updated_by_id }
    end

    assert_redirected_to sales_order_path(assigns(:sales_order))
  end

  test "should show sales_order" do
    get :show, id: @sales_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_order
    assert_response :success
  end

  test "should update sales_order" do
    patch :update, id: @sales_order, sales_order: { contact_user_id: @sales_order.contact_user_id, created_at: @sales_order.created_at, created_by_id: @sales_order.created_by_id, customer_user_id: @sales_order.customer_user_id, grand_total: @sales_order.grand_total, name: @sales_order.name, subtotal: @sales_order.subtotal, tax: @sales_order.tax, updated_at: @sales_order.updated_at, updated_by_id: @sales_order.updated_by_id }
    assert_redirected_to sales_order_path(assigns(:sales_order))
  end

  test "should destroy sales_order" do
    assert_difference('SalesOrder.count', -1) do
      delete :destroy, id: @sales_order
    end

    assert_redirected_to sales_orders_path
  end
end

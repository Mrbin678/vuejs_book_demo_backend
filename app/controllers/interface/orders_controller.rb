# -*- encoding : utf-8 -*-
class Interface::OrdersController < Interface::ApplicationController
  def get_all_orders
    if params[:order_status].present?
      if params[:order_status] == "true"
        orders = Order.where("order_status = ?", true).order("created_at desc")
      elsif params[:order_status] == "false"
        orders = Order.where("order_status = ?", false).order("created_at desc")
      end
    elsif params[:is_dispatch].present?
      orders = Order.where("is_dispatch= ?", params[:is_dispatch]).order("created_at desc")
    else
      orders = Order.all.order("created_at desc")
    end

    render :json => {
      orders: orders.map { |order|
        {
          id: order.id,
          order_id: order.order_id,
          total_cost: order.total_cost,
          order_status: order.order_status,
          is_dispatch: order.is_dispatch,
          goods: order.buy_goods.map { |buy_good|
            {
            good_name: buy_good.good.name,
            price: buy_good.good.price,
            quantity: buy_good.quantity,
            good_image: buy_good.good.show_goods_first_image,
            }
          }
        }
      }
    }
  end
end

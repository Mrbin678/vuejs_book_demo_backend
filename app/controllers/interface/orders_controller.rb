# -*- encoding : utf-8 -*-
class Interface::OrdersController < Interface::ApplicationController
  def get_all_orders
    orders = Order.all

    render :json => {
      orders: orders.map { |order|
        {
          id: order.id,
          order_id: order.order_id,
          total_cost: order.total_cost,
          order_status: order.order_status,
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

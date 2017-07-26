# -*- encoding : utf-8 -*-
class Interface::GoodsController < Interface::ApplicationController
  def get_goods
    goods = Good.all

    render :json => {
      goods: goods.map { |good|
        {
          id: good.id,
          name: good.name,
          description: good.description,
          image_url: good.image_url,
          category_id: good.category_id
        }
      }
    }
  end
end

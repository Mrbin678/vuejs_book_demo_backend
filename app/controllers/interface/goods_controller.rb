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
          image_url: good.goods_photos.first.image_url,
          category_id: good.category_id
        }
      }
    }
  end

  def goods_details
    good = Good.find(params[:good_id])

    render :json => {
      good: {
        id: good.id,
        name: good.name,
        description: good.description,
        price: good.price,
        category_id: good.category_id
      },
      good_images: good.goods_photos.map { |photo|
         photo.image_url
      }
    }
  end
end

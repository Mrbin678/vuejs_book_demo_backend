class Good < ActiveRecord::Base
  belongs_to :category
  has_many :goods_photos
  has_many :buy_goods
  has_many :comments
  belongs_to :shop_cart

  def show_goods_first_image
    self.goods_photos.first.image_url
  end
end

class Good < ActiveRecord::Base
  belongs_to :category
  has_many :goods_photos
  has_many :buy_goods
end

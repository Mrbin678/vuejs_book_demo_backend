class Good < ActiveRecord::Base
  belongs_to :category
  has_many :goods_photos
end

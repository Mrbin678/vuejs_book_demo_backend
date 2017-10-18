class ShopCart < ActiveRecord::Base
  belongs_to :member_user
  has_many :goods
end

class Order < ActiveRecord::Base
  has_many :buy_goods
end

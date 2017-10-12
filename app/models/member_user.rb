class MemberUser < ActiveRecord::Base
  has_many :comments
  has_many :user_addresses
  has_many :orders
end

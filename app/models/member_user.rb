class MemberUser < ActiveRecord::Base
  has_many :comments
end

# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

 def test_before_create_callback
    Customer.transaction do
      Rails.logger.info ("#{Time.now}")
      open_id = 'opFELv0qmBbe3HMFKNWFlRfRMGC0'
      #role = 'lingdui'
      role = 'yonghu'
      nick_name = '杜骁'
      invitation_id = 4
      if role == 'lingdui'
        level_id = 1
      end
      @customer = Customer.find_by_open_id(open_id)
      if @customer.present?
        @customer.account.destroy
        @customer.destroy
      end
      Customer.create level_id: level_id, nick_name: nick_name, role: role, open_id: open_id, invitation_id: invitation_id, register_id: Customer.new.generate_register_id
      puts 'create end'
    end
 end

 def test_after_create_call_back
    Customer.transaction do
      Rails.logger.info ("#{Time.now}")
      delete_test_data = true
      role = 'lingdui'
      #role = 'yonghu'
      invitation_id = 4
      if role == 'lingdui'
        level_id = 1
      end
      if delete_test_data
        @customers = Customer.where("open_id like '%test_customer%'")
        @accounts = Account.joins(:account).where.("customers.open_id like '%test_customer%'")
        @customers.destroy_all
        @accounts.destroy_all
      end
      total_number = 9
      (0..total_number - 1).each do |index|
        open_id = 'test_customer=' + (index + 1).to_s
        nick_name = '杜骁' + (index + 1).to_s
        Customer.create level_id: level_id, nick_name: nick_name, role: role, open_id: open_id, invitation_id: invitation_id, register_id: Customer.new.generate_register_id
      end
    end
 end

 def level_up
   open_id = 'opFELv0qmBbe3HMFKNWFlRfRMGC0'
   url = 'http://localhost:3000/interface/customers/level_up?open_id=' + open_id
   response = HTTParty.post url
 end

test_before_create_callback()
#test_after_create_call_back()
#level_up()

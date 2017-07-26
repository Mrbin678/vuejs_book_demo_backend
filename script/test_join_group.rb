# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails'
require 'rubygems'
require 'httparty'

 def test_one_man_join_group
    Rails.logger.info ("#{Time.now}")
    group_buying_id = 5
    price = 200
    open_id = 'opFELv0qmBbe3HMFKNWFlRfRMGC0'
    CustomerGroup.transaction do
      @customer = Customer.find_by_open_id(open_id)
      @customer_groups = CustomerGroup.joins(:customer).where("customers.open_id = ?", open_id)
      @orders = CustomerGroup.joins(:order).where("customers.open_id = ?", open_id)
      @customer_groups.destroy_all
      if @customer.present?
        CustomerGroup.create group_buying_id: group_buying_id, customer_id: @customer.id
        #Order.create customer_id: @customer.id, group_buying_id: group_buying_id, price: price
      end
    end
    puts 'join group success end'
 end

 def test_after_create_call_back
    Rails.logger.info ("#{Time.now}")
    group_buying_id = 5
    price = 200
    fee = 10
    @customers = Customer.where("customers.open_id like '%test_customer%'").limit(4)
    @customer_groups = CustomerGroup.joins(:customer).where("customers.open_id like '%test_customer%'")
    @orders = Order.joins(:customer).where("customers.open_id = '%test_customer%'")
    @customer_groups.destroy_all
    @orders.destroy_all
    Notification.destroy_all
    @customers.each do |customer|
      order = Order.create group_buying_id: group_buying_id, customer_id: customer.id, price: price, current_fee: fee
      CustomerGroup.create group_buying_id: group_buying_id, customer_id: customer.id, order_id: order.id
    end
    puts 'after_create end'
 end

#test_one_man_join_group()
test_after_create_call_back()

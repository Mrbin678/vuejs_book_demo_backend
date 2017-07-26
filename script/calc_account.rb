# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rufus/scheduler'
require 'rails'
require 'rubygems'
scheduler = Rufus::Scheduler.new

#每隔3小时
scheduler.every '3h' do
#scheduler.in '1s' do
  Rails.logger.info ("#{Time.now}")
  begin
    Rails.logger.info "===|| calc now starts ==="

    Account.transaction do
      Account.all.each do |account|
        account.update_attribute('ranking', (account.get_ranking rescue 0.0))
      end
    end


    Rails.logger.info "===|| calc now stops."
  rescue Exception => e
    Rails.logger.error "===|| #{e}"
    Rails.logger.error e
    Rails.logger.error e.backtrace.join("\n")
  end

end

scheduler.join

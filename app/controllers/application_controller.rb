# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery with: :exception
  include LoggableController
  before_filter :save_log
end

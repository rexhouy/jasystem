# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Load menu info
  before_action :menu

  def menu
    @menus = [{:url => "/orders", :text => "订单管理", :active => false},
             {:url => "/customers", :text => "客户管理", :active => false}]

    @menus.each do |menu|
      menu[:active] = menu[:url].eql? "/#{params[:controller]}"
    end
  end

end

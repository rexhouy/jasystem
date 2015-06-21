# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :exception

        # Authenticate users using devise
        # before_action :authenticate_user!

        # Load menu info
        before_action :menu

        def menu
                # @menus = [{:url => "/orders", :text => "订单管理", :active => false},
                #           {:url => "/reports", :text => "报表", :active => false},
                #           {:url => "/tasks", :text => "任务管理", :active => false}]
                @menus = [{:url => "/prints", :text => "图纸", :active => false},
                          {:url => "/price", :text => "报价", :active => false}]

                @menus.each do |menu|
                        menu[:active] = menu[:url].eql? "/#{params[:controller]}"
                end
        end

end

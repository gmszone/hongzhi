require 'sinatra'
require 'wei-backend'
require 'rubygems'
require './blog_helper'

token "xuntaphodal"

on_text do
    blog = BlogHelper.new
    blog.getdata(params[:Content])
end

on_subscribe do
    "感谢您的订阅"
end

on_unsubscribe do
    "欢迎您再次订阅"
end

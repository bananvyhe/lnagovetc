class MeshandlController < ApplicationController
	# before_action :user_params
	require 'httparty'
	skip_before_action :verify_authenticity_token
	# encoding: utf-8
	# require 'telegram/bot'
	require 'uri'

	def mesa
		puts "123"
 		token = Rails.application.credentials[:token]
 		mass = []
 		params.each_value do |value|
 			
 			if value == nil
  			mass << "не заполнено"
  		else
  			mass << value.to_s
  		end
 
		end

 		mesa = 'имя: '+mass[0]+' тел: '+mass[1]+' сообщение: '+mass[2]+' дата: '+mass[3]+' время: '+mass[4]
 
 		mesa = 'https://api.telegram.org/bot'+token+'/sendMessage?chat_id=199874565&text='+mesa 
 
	 	paf = URI::Parser.new
	 	paf = paf.escape(mesa)
	 	puts paf
 

		HTTParty.post(paf)
 
	end

  private
 
  # def user_params
  #   params.permit(:name,:mes, :phone, :text, :time, :data)
  # end	
end

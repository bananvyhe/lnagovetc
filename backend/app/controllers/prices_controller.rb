class PricesController < ApplicationController
	before_action :authorize_access_request!, only: [:saveitem, :getitem, :delitem, :aitem]

	def index
		@prices = Price.all
		render json: @prices.as_json(only: [:id, :cost, :name, :duration])
	end

	def delitem
		puts params[:id]
		@prices = Price.find(params[:id])
	  if @prices.destroy
	  	render json: @prices, status: :ok
	  else 	
	  end	 
	end	

	def aitem
 		@prices =  Price.new(price_params)
	  if @prices.save 
	  	render json: @prices, status: :ok
	  else 	
	  end	 
	end	

	def getitem
		full = Price.find(params[:id]) 
		render json: full
	end
	def saveitem 
	  @prices =  Price.find(params[:id]) 
	  if @prices.update(price_params)
	  	render json: @prices, status: :ok
	  else
	  end
	end
	private
  	def price_params
    	params.permit(:id, :name, :cost, :duration)
  	end	
end

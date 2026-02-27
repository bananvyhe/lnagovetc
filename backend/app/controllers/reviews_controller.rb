class ReviewsController < ApplicationController
before_action :authorize_access_request!, only: [:aitem, :delitem, :saverevitem]
	def index
		# request.format = :json
		@reviews = Review.all
 # format.html { render :index }
  # format.json { render json:  @reviews}
		render json: @reviews.as_json(only: [:id, :body, :name])
	end

	def aitem
 		@reviews =  Review.new(review_params)
	  if @reviews.save 
	  	render json: @reviews, status: :ok
	  else 	
	  end	 
	end	

	def delitem
		puts params[:id]
		@reviews = Review.find(params[:id])
	  if @reviews.destroy
	  	render json: @reviews, status: :ok
	  else 	
	  end	 
 
	end

	def saverevitem
		@reviews =  Review.find(params[:id]) 
	  if @reviews.update(review_params)
	  	render json: @reviews, status: :ok
	  else
	  end
	end

	def getrev
		full = Review.find(params[:id]) 
		render json: full
	end

	private
  	def review_params
    	params.permit(:id, :name, :body)
  	end		
end

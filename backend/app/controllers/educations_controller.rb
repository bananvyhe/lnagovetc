class EducationsController < ApplicationController
	before_action :authorize_access_request!, only: [:aitemed, :delitemed]
	def index
    @ed = Education.all
    render json: @ed.as_json(only: [:id, :desc, :main])
	end

	def aitemed
 		@educations =  Education.new(education_params)
	  if @educations.save 
	  	render json: @educations, status: :ok
	  else 	
	  end	 
	end	

	def delitemed
		puts params[:id]
		@educations = Education.find(params[:id])
	  if @educations.destroy
	  	render json: @educations, status: :ok
	  else 	
	  end	 
	end	
	private
  	def education_params
    	params.permit(:id, :desc, :main)
  	end			
end

class RedactorsController < ApplicationController
 
	def index
    @red = Redactor.all
    puts "--------------"
    puts @red
    puts "--------------"
    render json: @red	
	end

	def getcont
		full = Redactor.first
		render json: full
	end	

	def saveitem 
	  @redactors =  Redactor.first
	  if @redactors.update(redactor_params)
	  	render json: @redactors, status: :ok
	  else
	  end
	end	
	private
  	def redactor_params
    	params.permit(:id, :about, :consult)
  	end		 
end

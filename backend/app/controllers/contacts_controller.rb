class ContactsController < ApplicationController
	before_action :authorize_access_request!, only: [:savecontitem]
	def index
		@contact = Contact.all.order("id ASC")
		render json: @contact.as_json(only: [:id, :tel, :position, :desc])
	end	

	def getcont
		full = Contact.find(params[:id]) 
		render json: full
	end	

	def savecontitem
		if params[:id] == 1
		@contacts =  Contact.order("id ASC").first
		if @contacts.update(contact_params)
			render json: @contacts, status: :ok
		end
	elsif params[:id] == 2
		fa = Contact.order("id ASC").limit(1).offset(params[:id]-1)
		puts fa.inspect
		if fa.update(contact_params)
			render json: fa, status: :ok
		end 
	elsif params[:id] == 3
		fa = Contact.order("id ASC").limit(1).offset(params[:id]-1)
		
		if fa.update(contact_params)
			render json: fa, status: :ok
		end
	elsif params[:id] == 10
		fa = Contact.order("id ASC").first
		if fa.update(contact_params)
			render json: fa, status: :ok
		end 		 		
	end

	puts params[:id]
	  # if @contacts.update(contact_params)
	  # 	render json: @contacts, status: :ok
	  # else
	  # end
	end	

	private
  	def contact_params
    	params.permit(:id, :desc, :tel, :position)
  	end			
end

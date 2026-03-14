class MeshandlController < ApplicationController
	# before_action :user_params
	require 'httparty'
	skip_before_action :verify_authenticity_token
	# encoding: utf-8
	# require 'telegram/bot'
	require 'uri'

	def mesa
 		token = Rails.application.credentials.dig(:telegram, :bot_token) ||
 		         Rails.application.credentials[:token] ||
             Rails.application.credentials[:farmspot_bot] ||
             Rails.application.credentials[:farmspot_bo]
 		chat_id = Rails.application.credentials.dig(:telegram, :chat_id) ||
 		          Rails.application.credentials[:chat_id] ||
              Rails.application.credentials[:char_id]

		return head :unprocessable_entity if token.blank? || chat_id.blank?

		data = message_params
		message = [
			"имя: #{data[:name].presence || 'не заполнено'}",
			"тел: #{data[:phone].presence || 'не заполнено'}",
			"сообщение: #{data[:text].presence || 'не заполнено'}",
			"дата: #{data[:data].presence || 'не заполнено'}",
			"время: #{data[:time].presence || 'не заполнено'}"
		].join(' ')

		response = HTTParty.post(
			"https://api.telegram.org/bot#{token}/sendMessage",
			body: { chat_id: chat_id, text: message }.to_json,
			headers: { 'Content-Type' => 'application/json' }
		)
		return head :ok if response.success?

		render json: { error: "Telegram request failed" }, status: :bad_gateway
	end

  private
 
  def message_params
    params.permit(:name, :phone, :text, :time, :data)
  end
end

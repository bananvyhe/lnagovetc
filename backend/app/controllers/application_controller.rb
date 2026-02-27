class ApplicationController < ActionController::Base
	# before_action :set_default_format
	# protect_from_forgery with: :null_session
	# skip_forgery_protection
	# protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	# protect_from_forgery with: :exception
	include JWTSessions::RailsAuthorization
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  # rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  protect_from_forgery with: :null_session,
  if: Proc.new { |c| c.request.format =~ %r{application/json} }
	private

  def set_html_format
    request.format = :html
  end
  def set_default_format
    request.format = :json
  end
  def current_user
    @current_user ||= User.find(payload['user_id'])
  end
  def not_authorized
    render json: { error: 'ошибка авторизации!' }, status: :unauthorized
  end  
  def not_found
    render json: { error: 'не найдено' }, status: :not_found
    # raise ActionController::RoutingError.new('Not Found')
    # render status: 404
    # render :text => 'Not Found', :status => '404'
    # render(:status => 404)

  end    
  def internal_server_error
    render json: { error: 'ошибка сервера' }, status: :internal_server_error
    # render(:status => 500)
  end  
  def forbidden
    render json: { error: 'Forbidden' }, status: :forbidden
  end  
end

class WelcomeController < ApplicationController
  def index
    frontend_origin = ENV.fetch("FRONTEND_ORIGIN", "http://localhost:5173")
    path = request.fullpath == "/" ? "" : request.fullpath

    redirect_to "#{frontend_origin}#{path}", allow_other_host: true
  end
end

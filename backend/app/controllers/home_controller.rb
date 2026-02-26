class HomeController < ApplicationController
  def index; end

  def enqueue_hello
    HelloJob.perform_later
    render json: { status: "queued" }
  end
end

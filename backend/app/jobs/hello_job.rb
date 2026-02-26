class HelloJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("HelloJob performed")
  end
end

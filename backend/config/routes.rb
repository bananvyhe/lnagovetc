Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  post "/hello_job", to: "home#enqueue_hello"
end

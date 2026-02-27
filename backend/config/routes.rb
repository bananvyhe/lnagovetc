Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "welcome#index"

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
  post "mesa", controller: :meshandl, action: :mesa
  resources :todos
  get "me", controller: :users, action: :me

  get "admin/users", to: "admin/users#allus"
  get "admin/use", to: "welcome#index"
  get "admin/red", to: "welcome#index"

  post "arevitem", to: "reviews#aitem"
  delete "delrevitem/:id", to: "reviews#delitem"
  post "saverevitem", to: "reviews#saverevitem"
  post "getrev", to: "reviews#getrev"
  get "rev", to: "welcome#index"
  get "reviews", to: "reviews#index"

  get "prices", to: "prices#index"
  get "pricel", to: "welcome#index"
  delete "delitem/:id", to: "prices#delitem"
  post "aitem", to: "prices#aitem"
  post "getitem", to: "prices#getitem"
  post "saveitem", to: "prices#saveitem"

  get "contacts", to: "contacts#index"
  get "cont", to: "welcome#index"
  post "getcont", to: "contacts#getcont"
  post "savecontitem", to: "contacts#savecontitem"

  get "redactors", to: "redactors#getcont"
  post "saveredtitem", to: "redactors#saveitem"

  get "requests", to: "requests#index"
  post "aitemzap", to: "requests#aitem"
  delete "delitemreq/:id", to: "requests#delitemreq"

  get "educations", to: "educations#index"
  post "aitemed", to: "educations#aitemed"
  delete "delitemed/:id", to: "educations#delitemed"

  get "404", to: "errors#not_found"
  get "500", to: "welcome#index", as: :internal_server_error
end

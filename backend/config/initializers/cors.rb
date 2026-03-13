Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173",
            "http://127.0.0.1:5173",
            ENV.fetch("FRONTEND_ORIGIN", "http://localhost:5173"),
            "https://nagovetc.ru",
            "https://www.nagovetc.ru"

    resource "*",
      headers: :any,
      credentials: true,
      methods: %i[get post put patch delete options head]
  end
end

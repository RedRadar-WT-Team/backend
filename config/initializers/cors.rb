Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173", "http://localhost:5174", "https://frontend-9cax.onrender.com", "https://frontend-itj0.onrender.com"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head], 
      credentials: true


  end

end
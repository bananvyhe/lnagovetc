JWTSessions.encryption_key = Rails.application.secret_key_base
JWTSessions.token_store = :redis, { redis_url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/1") }
JWTSessions.access_exp_time = 300

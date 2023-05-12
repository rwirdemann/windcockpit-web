json.extract! session, :id, :sport, :created_at, :updated_at
json.url session_url(session, format: :json)

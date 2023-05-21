json.extract! session, :id, :sport, :spot_id, :when, :duration, :distance, :maxspeed, :created_at, :updated_at
json.url session_url(session, format: :json)

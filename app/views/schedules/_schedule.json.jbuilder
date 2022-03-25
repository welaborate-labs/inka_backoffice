json.extract! schedule, :id, :weekday, :starts_at, :ends_at, :interval_starts_at, :interval_ends_at, :professional_id, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)

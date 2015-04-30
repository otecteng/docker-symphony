json.array!(@containers) do |container|
  json.extract! container, :id, :name, :uuid, :tag_id
  json.url container_url(container, format: :json)
end

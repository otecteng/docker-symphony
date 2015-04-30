json.array!(@dockers) do |docker|
  json.extract! docker, :id, :name
  json.url docker_url(docker, format: :json)
end

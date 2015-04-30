require_relative 'spec_helper.rb'

describe Tag do
  tag = Tag.create(:name=>"latest")
  tag.repository = Repository.create(:name=>"ubuntu")
  docker_file = "RUN mkdir /lt"
  tag.create_image(docker_file)

end
require_relative 'spec_helper.rb'

describe Container do
  d = Docker.create(:name=>"172.16.143.235")
  p d.image_list
end
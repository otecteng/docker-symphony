class Docker < ActiveRecord::Base
  include DockerRemoteApi
  has_many :containers
  has_many :images
  def pull tag
    request "/images/create?fromImage=10.240.16.106:5000/#{tag.repository.name}"
  end

  def clear
    containers.each do |c|
      c.rm
      c.delete
    end
  end

  def sync
    get("/containers/json?all=1").each.map{|container|
      c = containers.create(:uuid=>container["Id"])
      c.detail
    }
  end

  def docker
    self
  end

  def image_list
    get("/images/json").each.map{|image|
      p image["Id"]
      image_db = self.images.find_by_uuid(image["Id"])
      image_db = self.images.create(:uuid=>image["Id"]) unless image_db
      p image_db.id
      image_db.name=image["RepoTags"].to_json
      image_db.save!
    }
  end
end

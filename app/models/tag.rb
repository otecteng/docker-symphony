require 'faraday'
require 'net/http'

class Tag < ActiveRecord::Base
  include DockerRemoteApi
  belongs_to :image
  belongs_to :repository
  has_many :containers
  def self.sync
    Repository.delete_all
    Tag.delete_all
    Image.delete_all
    repos = read("/v1/search")["results"].map { |repo|
      repo = Repository.create(:name=>repo['name'])
      read("/v1/repositories/#{repo.name}/tags").each do |k,v|
        tag = repo.tags.create(:name=>k,:uuid=>v)
        image_docker = read("/v1/images/#{v}/json")
        image = Image.create(:uuid=>v,:container_config=>image_docker['config'].to_json)
        tag.image = image
        tag.save!
      end
    }
  end

  def self.read url
    conn = Faraday.new("http://10.240.16.106:5000")
    response = conn.get(url)
    JSON.parse(response.body)
  end

  def create_container(name=nil)
    docker = Docker.last
    docker.pull(self)
    container = self.containers.build(:name=>name)
    container.docker = docker
    container.save!
    container.run
  end

  def create_image(docker_file)
    docker = Docker.last
    image = Image.create(:docker_file=>docker_file)
    File.open("Dockerfile",'w') do |file|
      file.write("FROM #{repository.name}:#{self.name}\n")
      file.write(docker_file)
    end
    `tar zcf Dockerfile.tar.gz Dockerfile`
    ret = build_image(docker.name,'/build?force=1&repo=tt&tag=v1',"Dockerfile.tar.gz")
    s = ret.split("\r\n").find{|x| x =~ /Successfully built/}    
    p JSON.parse(s)['stream'].scan(/Successfully built(.*)\n/).first.first.strip

    # image.uuid = 
    # save!
    # push
  end

  def to_s
    "10.240.16.106:5000/#{repository.name}:#{self.name}"
  end

  def docker
    image.docker
  end
  def docker_file
    image.docker_file
  end

  def docker_file=(val)
    image.docker_file = val
    image.save
  end

  def build_image docker,url,file
    host = "http://#{docker}:2375"
    uri = URI("#{host}/v1.17#{url}")
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new("/v1.17#{url}")
    req.body = File.binread(file)
    req.content_type = 'application/tar'
    # req.X-Registry-Config = base64-encoded ConfigFile objec
    p req.path
    x = http.request(req).body
    p x
    x
  end

end

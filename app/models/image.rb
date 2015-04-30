class Image < ActiveRecord::Base
  include DockerRemoteApi
  belongs_to :docker
  def push(repo)
    args = JSON.parse(name).first.split(':')
    tag = args.last if args.length > 2
    request "/v1.17/images/#{repo}/push?tag=",{},:get
  end
end

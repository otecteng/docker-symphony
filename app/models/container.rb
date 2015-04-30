class Container < ActiveRecord::Base
  belongs_to :tag
  belongs_to :docker
  # ACTIONS = [:run,:start,:stop,:restart,:kill,:pause,:unpause]
  include DockerRemoteApi

  def run
    ret = request '/containers/create', 
            {
              "HostConfig"=>{"PublishAllPorts"=>true},
              "Image"=>tag.image.uuid.to_s,
              "Hostname"=>name,
            }
    self.update_attributes(:uuid=>ret["Id"])
    self.start
    self.rename(:name=>name)
    self.detail
  end

  def detail
    data = get("/containers/#{uuid}/json",{})
    self.update_attributes(:name=>data["Name"],
      :host_config=>data["HostConfig"].to_json,
      :network_settings=>data["NetworkSettings"].to_json,
      :state=>data["State"].to_json
      )
    tag = Tag.find_by_uuid(data["Image"])
    self.tag = tag
    self.save!
  end
  
  def rm
    stop
    request "/containers/#{uuid}",{},:delete
  end

  def ports
    JSON.parse(network_settings)["Ports"] if network_settings
  end

  def running?
    state.present? && JSON.parse(state)["Running"]
  end
end

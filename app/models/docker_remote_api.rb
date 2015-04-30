require 'faraday'
module DockerRemoteApi
  def self.included(kclass)
    base = kclass.name.downcase
    methods = case base
      when "container"
        [:start,:stop,:restart,:kill,:pause,:unpause,:rename]
      when "image"
        [:tag]
      when "misc"
        []
      else
        []
    end
    methods.each do |m|
      define_method(m) do |*args|
        request "/v1.17/#{base}s/#{uuid}/#{m}",args.first||{},:get
      end
    end
  end


  def get(url,params={})
    begin
      conn = Faraday.new("http://#{docker.name}:2375/v1.17")
      response = conn.get(url,params)
      JSON.parse(response.body)    
    rescue Exception => e
      {}      
    end
  end

  def request(url,params={},method=:post)
    # begin
      host = "http://#{docker.name}:2375"
      http = Net::HTTP.new(host)
      conn = Faraday.new(:url => host)
      ret = case method
      when :post
        conn.headers = {'Content-Type' => 'application/json'}
        JSON.parse(conn.send(method,url,params.to_json).body)
      when :delete
        Net::HTTP::Delete.new(url)
        JSON.parse(http.request(request).body)
      when :get
        args = params.map{|k,v|"#{k}=#{v}"}.join('&')
        if args.present?
          url = url + "?" unless url =~ /\?/
          url = "#{url}#{args}"
        end
        conn.post(url)
      end
    # rescue Exception => e
    #   p e
    #   ret = {}  
    # end
    p ret
    ret
  end
end
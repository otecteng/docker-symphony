require 'faraday'
require 'net/http'
module DockerHubApi
  def self.request(url,params={},method=:post)
    # begin
      host = "http://172.16.143.235"
      conn = Faraday.new(:url => host)
      ret = case method
      when :post
        conn.headers = {'Content-Type' => 'application/json'}
        JSON.parse(conn.send(method,url,params.to_json).body)
      when :delete
        JSON.parse(conn.delete(url).body)
      when :get
        conn.post("#{url}?#{params.map{|k,v|"#{k}=#{v}"}.join('&')}")
      end
    # rescue Exception => e
    #   p e
    #   ret = {}  
    # end
    p ret
    ret
  end  
end
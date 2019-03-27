require "active_support/all"
require "net/http"

module FalconTools
  class Interface

    def initialize
      @token = nil
      @token_expiration = nil
      authenticate
    end

    def find(type, project_id=nil)
      if @token
        url = "Energy/#{type.to_s.camelize}"
        url += "/#{project_id}" if project_id
        response = authorized_request(:get, url)
      else
        {}
      end
    end

    def find_project_by_name(name)
      projects = find(:projects)
      project = projects.select{ |p| p["model"]["name"] == name }.first
      project["key"] unless project.blank?
    end

    private 

    def authorized_request(method, resource, data=nil)
      reauthenticate if token_expired?
      send_request(method, resource, data)
    end

    def authenticate
      @token = send_request(:post, "accounts/authenticate", { 
        username: ENV['FALCON_TOOLS_USERNAME'], 
        password: ENV['FALCON_TOOLS_PASSWORD']
      })
      set_token_expiration if @token
    end

    def reauthenticate
      @token = send_request(:post, "accounts/renewAuthentication", {
        token: @token
      })
      set_token_expiration if @token
    end

    def token_expired?
      @token_expiration ? @token_expiration < DateTime.now : true
    end

    def set_token_expiration
      decoded_expiration_date = JSON.parse(Base64.decode64(@token.split('.').first))["expiration"]
      @token_expiration = DateTime.parse(decoded_expiration_date)
    end

    def send_request(method, resource, data=nil)
      base_url = "https://falcontools.aecomassetmanagement.com/api"
      uri = URI("#{base_url}/#{resource}")
      request = create_request(method, uri, data)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        JSON.parse(response.body) if response.body
      else
        puts response.body
        false
      end
    end

    def create_request(method, uri, data)
      case method
      when :get
        uri.query = URI.encode_www_form(data) if data
        Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json', 'auth' => @token)
      when :post
        request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        request.body = data.to_json if data
        request
      when :delete
        request = Net::HTTP::Delete.new(uri)
        request.body = data.to_json if data
        request
      end
    end
  
  end
end

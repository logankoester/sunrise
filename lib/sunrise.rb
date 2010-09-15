require 'rest_client'
require 'json'

module Sunrise

  class Client
    attr_accessor :login, :password, :response, :host, :port
    def initialize(login, password, host = 'sunrisehq.com', port = '80')
      @login, @password, @host, @port = login, password, host, port
    end

    def upload(file, team, name = nil)
      name = default_name(file) unless name
      url = "http://#{@login}:#{@password}@#{team}.sunrisehq.local:3000/upload.json"
      @response = RestClient.post url,
        :item => {
          :type  => 'Screenshot',
          :image => File.new(file),
          :name  => name,
        },
        :content_type => :json,
        :accept => :json
    end

    # Fetch an array of teams from an account
    def teams
      url = "http://#{@login}:#{@password}@#{@host}:#{@port}/team.json"
      @response = RestClient.get url#, :content_type => :json, :accept => :json
      teams = []
      JSON.parse(@response).each { |team| teams << team['team']['subdomain'] }
      return teams
    end

  private
    # If no name for an upload is specified, set a default name using the 
    # first part of the filename.
    def default_name(file)
      File.basename(file.path)
    end
  end

end

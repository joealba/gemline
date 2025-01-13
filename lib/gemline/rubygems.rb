class Gemline
  class Rubygems
    def self.get_rubygem_json(gem_name)
      uri = URI.parse("https://rubygems.org/api/v1/gems/#{gem_name}.json")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response.body
    end
  end
end

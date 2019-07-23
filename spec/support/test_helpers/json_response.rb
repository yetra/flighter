module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body)
    end

    def api_headers(token: nil)
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': (token unless token.nil?)
      }
    end
  end
end

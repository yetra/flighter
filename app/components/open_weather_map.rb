module OpenWeatherMap
  BASE_URL = 'https://api.openweathermap.org/data/2.5/'

  def self.fetch(path, params)
    Faraday.get(
      BASE_URL + path, params.merge(appid: Rails.application.credentials.open_weather_map_api_key)
    )
  end

  def self.city(city_name)
    city_id = OpenWeatherMap::Resolver.city_id(city_name)
    return if city_id.nil?

    response = fetch('weather', id: city_id)

    OpenWeatherMap::City.parse(JSON.parse(response.body))
  end

  def self.cities(city_names)
    city_names.map(&method(:city)).compact
  end
end

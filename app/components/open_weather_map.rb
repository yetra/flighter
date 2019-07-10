module OpenWeatherMap
  def self.city(city_name)
    city_id = OpenWeatherMap::Resolver.city_id(city_name)

    return if city_id.nil?

    url = 'https://api.openweathermap.org/data/2.5/weather'
    response = Faraday.get(
      url, id: city_id, appid: Rails.application.credentials.open_weather_map_api_key
    )

    OpenWeatherMap::City.parse(JSON.parse(response.body))
  end

  def self.cities(city_names)
    city_names.map(&method(:city))
  end
end

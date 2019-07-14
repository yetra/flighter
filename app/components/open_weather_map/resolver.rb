module OpenWeatherMap
  class Resolver
    def self.city_id(city_name)
      city_ids_path = File.expand_path('city_ids.json', __dir__)
      city_ids_file = File.read(city_ids_path)
      city_ids = JSON.parse(city_ids_file)

      city_ids.find { |city| city['name'] == city_name }.try(:fetch, 'id')
    end
  end
end

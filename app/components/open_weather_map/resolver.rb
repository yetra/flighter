module OpenWeatherMap
  class Resolver
    def self.city_id(city_name)
      require 'json'

      city_ids_path = File.expand_path('city_ids.json', __dir__)
      city_ids_file = File.read(city_ids_path)
      city_ids = JSON.parse(city_ids_file)

      city_ids.each do |city|
        return city['id'] if city['name'] == city_name
      end

      nil
    end
  end
end

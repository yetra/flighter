module OpenWeatherMap
  class City
    include Comparable
    attr_reader :id, :lat, :lon, :name

    def initialize(id:, lat:, lon:, name:, temp_k:)
      @id = id
      @lat = lat
      @lon = lon
      @name = name
      @temp_k = temp_k
    end

    def temp
      @temp_k - 273.15
    end

    def <=>(other)
      return nil unless other.is_a?(self.class)

      [temp, name] <=> [other.temp, other.name]
    end

    def self.parse(city_hash)
      new(
        id: city_hash['id'],
        lat: city_hash['coord']['lat'],
        lon: city_hash['coord']['lon'],
        name: city_hash['name'],
        temp_k: city_hash['main']['temp']
      )
    end

    def nearby(count = 5)
      response = OpenWeatherMap.fetch('find', lat: lat, lon: lon, cnt: count)

      city_hashes = JSON.parse(response.body)['list']
      city_hashes.map { |city_hash| self.class.parse(city_hash) }
    end

    def coldest_nearby(count = 5)
      nearby(count).min
    end
  end
end

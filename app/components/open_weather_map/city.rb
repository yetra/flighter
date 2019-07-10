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
      compare_temp = temp <=> other.temp

      return name <=> other.name if compare_temp.zero?

      compare_temp
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
  end
end

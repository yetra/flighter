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
  end
end

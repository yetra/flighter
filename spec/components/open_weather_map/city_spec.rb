RSpec.describe OpenWeatherMap::City do
  let(:city) do
    described_class.new(id: 2_172_797, lat: -16.92, lon: 145.77, name: 'Cairns', temp_k: 300.15)
  end

  it 'returns initialized id' do
    expect(city.id).to eq(2_172_797)
  end

  it 'returns initialized lat' do
    expect(city.lat).to eq(-16.92)
  end

  it 'returns initialized lon' do
    expect(city.lon).to eq(145.77)
  end

  it 'returns initialized name' do
    expect(city.name).to eq('Cairns')
  end

  it 'converts temperature to Celsius' do
    expect(city.temp).to eq(27)
  end

  it 'compares to other with higher temperature' do
    other = described_class.new(
      id: 7_839_402, lat: -12.40, lon: 130.88, name: 'Darwin', temp_k: 315.15
    )

    expect(city).to be < other
  end

  it 'compares to other with same temperature and alphabetically smaller name' do
    other = described_class.new(
      id: 2_959_374, lat: 52.05, lon: 9.26, name: 'Aerzen', temp_k: 300.15
    )

    expect(city).to be > other
  end

  it 'compares to other with same temperature and name' do
    expect(city).to be == city
  end

  it 'compares to other with same temperature and alphabetically larger name' do
    other = described_class.new(
      id: 3_186_886, lat: 45.81, lon: 15.98, name: 'Zagreb', temp_k: 300.15
    )

    expect(city).to be < other
  end
end

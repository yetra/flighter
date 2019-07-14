RSpec.describe OpenWeatherMap::Resolver do
  it 'returns id for known city name' do
    expect(described_class.city_id('Zagreb')).to eq(3_186_886)
  end

  it 'returns nil for unknown city name' do
    expect(described_class.city_id('NoName')).to be_nil
  end
end

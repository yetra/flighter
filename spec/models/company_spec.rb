RSpec.describe Company do
  describe 'associations' do
    subject { FactoryBot.create(:company) }

    it { is_expected.to have_many(:flights) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:company) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end

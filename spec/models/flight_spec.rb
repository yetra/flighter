RSpec.describe Flight do
  describe 'associations' do
    subject { FactoryBot.create(:flight_with_bookings) }

    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:bookings) }
  end

  describe 'validations' do
    subject(:flight_subject) { FactoryBot.create(:flight) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:company_id) }

    it { is_expected.to validate_presence_of(:flys_at) }
    it { is_expected.to validate_presence_of(:lands_at) }

    it 'has flys_at before lands_at' do
      expect(flight_subject.flys_at).to be < flight_subject.lands_at
    end

    it { is_expected.to validate_presence_of(:base_price) }
    it { is_expected.to validate_numericality_of(:base_price).is_greater_than(0) }

    it { is_expected.to validate_presence_of(:no_of_seats) }
    it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

    it "doesn't overlap flights from the same company" do
      expect(described_class.overlapping_flys_at(flight_subject)).to be_empty
      expect(described_class.overlapping_lands_at(flight_subject)).to be_empty
    end
  end
end

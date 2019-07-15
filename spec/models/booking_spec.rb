RSpec.describe Booking do
  describe 'associations' do
    subject { FactoryBot.create(:booking) }

    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:flight) }
  end

  describe 'validations' do
    subject(:booking_subject) { FactoryBot.create(:booking) }

    it { is_expected.to validate_presence_of(:seat_price) }
    it { is_expected.to validate_numericality_of(:seat_price).is_greater_than(0) }

    it { is_expected.to validate_presence_of(:no_of_seats) }
    it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

    it 'does not have flight in the past' do
      expect(booking_subject.flight.flys_at).to be >= DateTime.now
    end
  end
end

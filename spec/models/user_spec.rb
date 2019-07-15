RSpec.describe User do
  describe 'associations' do
    subject { FactoryBot.create(:user_with_bookings) }

    it { is_expected.to have_many(:bookings) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('user-1@email.com').for(:email) }
    it { is_expected.not_to allow_value('user-1email.com').for(:email) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
  end
end

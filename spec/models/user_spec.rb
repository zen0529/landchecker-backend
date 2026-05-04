require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    
    subject { build(:user) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should have_many(:watchlist_items).dependent(:destroy) }
    it { should have_many(:watched_properties).through(:watchlist_items).source(:property) }
  end

  describe 'callbacks' do
    it 'downcases email before saving' do
      user = create(:user, email: 'UPPERCASE@EXAMPLE.COM')
      expect(user.email).to eq('uppercase@example.com')
    end
  end
end

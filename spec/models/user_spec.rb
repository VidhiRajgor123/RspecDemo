require 'rails_helper'

RSpec.describe User, type: :model do
    # user = { User.new(name: "Demo", email: "demo@demo.com") }
    user = FactoryBot.create(:user)

    before { user.save }

    it 'name should be present' do
        user.name = nil
        expect(user).to_not be_valid
    end

    it 'email should be present' do
        user.email = nil
        expect(user).to_not be_valid
    end

    it 'email is invalid if the email is not unique' do
        expect(user).to be_invalid
    end
  
end
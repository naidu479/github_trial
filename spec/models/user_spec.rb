require 'rails_helper'

RSpec.describe User, :type => :model do
	let(:user) { FactoryGirl.build(:user) }

	context 'validations' do
		#addhere
    it { expect(user).to validate_presence_of(:name) }
	end
end

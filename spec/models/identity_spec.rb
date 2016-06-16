require 'rails_helper'

RSpec.describe Identity, :type => :model  do
	let(:identity) { FactoryGirl.create(:identity) }
	let(:identity_build) { FactoryGirl.build(:identity) }

	context 'validations' do
		it { expect(identity_build).to validate_presence_of(:uid) }
		it { expect(identity_build).to validate_presence_of(:accesstoken) }
		it { expect(identity_build).to validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive.with_message("has already been taken")}
		it { expect(identity_build).to validate_uniqueness_of(:accesstoken).scoped_to(:provider).case_insensitive.with_message("has already been taken")}
	end
	
end

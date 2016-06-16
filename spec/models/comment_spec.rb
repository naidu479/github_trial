require 'rails_helper'

RSpec.describe Comment, :type => :model do
	let(:comment) { FactoryGirl.build(:comment) }

	context 'validations' do
		#addhere
    it { expect(comment).to validate_presence_of(:text) }
	end
end

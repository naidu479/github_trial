require 'rails_helper'

describe PostPolicy do
  subject { PostPolicy.new(user, post) }

  let(:post) { Post.create }

  #add_here
context "being a/an admin" do
                          let(:user) {  User.create('roles' => 'admin', 'email' => 'first@first.com', 'password' => 'abcdabcd') }
                          # Action Specs :: Admin
it { should permit_action(:destroy) }
it { should permit_action(:update) }
it { should permit_action(:show) }
it { should permit_action(:create) }
                          # Attribute Specs :: Admin
it { should permit_mass_assignment_of(:user_id) }
it { should permit_mass_assignment_of(:body) }
it { should permit_mass_assignment_of(:title) }
                        end

end

require 'rails_helper'

describe CommentPolicy do
  subject { CommentPolicy.new(user, comment) }

  let(:comment) { Comment.create }

  #add_here
context "being a/an admin" do
                          let(:user) {  User.create('roles' => 'admin', 'email' => 'first@first.com', 'password' => 'abcdabcd') }
                          # Action Specs :: Admin
it { should permit_action(:destroy) }
it { should permit_action(:update) }
it { should permit_action(:show) }
it { should permit_action(:create) }
                          # Attribute Specs :: Admin
                        end

end

require 'rails_helper'

describe PostPolicy do
  subject { PostPolicy.new(user, post) }

  let(:post) { Post.create }

  #add_here

end

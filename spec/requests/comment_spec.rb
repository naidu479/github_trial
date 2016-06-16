require 'rails_helper'

  context "json API" do

    describe "Create" do

      let(:user) { FactoryGirl.create :user } #create
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" } #create
      @comment_params = FactoryGirl.build(:comment, user: user).attributes
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
      end


      context "with valid attributes" do
        it "should create the comment" do
          expect { post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: @comment_params, format: :json }.to change(Comment, :count).by(1)
        end

        it 'responds with 201' do
          post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: @comment_params, format: :json
          expect(response).to have_http_status(201)
        end
      end

 

       context 'with invalid attributes' do
        it 'does not create the comment' do
          @comment = post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: FactoryGirl.build(:comment).attributes.symbolize_keys, format: :json
          comment = FactoryGirl.build(:comment).attributes.symbolize_keys
          comment[:text] = ""
          expect { post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: comment, format: :json }.to_not change(Comment, :count)
        end

        it 'responds with 422' do
          @comment = post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: FactoryGirl.build(:comment).attributes.symbolize_keys, format: :json
          comment = FactoryGirl.build(:comment).attributes.symbolize_keys
          comment[:text] = ""
          post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: comment, format: :json
          expect(response).to have_http_status(422)
        end
      end

    end  


    describe "Index" do 

      let(:user) { FactoryGirl.create :user } #index
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
        3.times { post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: FactoryGirl.build(:comment).attributes.symbolize_keys, format: :json}
      end

      it "should fetch the correct number of comments" do
        get "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", page: 1, per: 2
        expect(json_response.count == 2).to eql(true)
      end

      it "should fetch the correct comments" do
        get "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", page: 1, per: 2
        json_response1 = json_response.clone
        get "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", page: 2, per: 2
        json_response2 = json_response.clone
        expect(json_response1.collect { |j1| j1['id'] } + json_response2.collect { |j2| j2['id'] }) .to eq(Comment.all.collect(&:id))
      end
      
      it "responds with 200" do
        get "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response).to have_http_status(200)
      end

    end

    describe "Show" do 

      let(:user) { FactoryGirl.create :user } #show
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
        post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: FactoryGirl.build(:comment).attributes.symbolize_keys, format: :json
      end

      it "should fetch the required comment" do
        get "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(json_response['id']).to eql(@post.comments.last.id)
      end
      
      it "responds with 200" do
        get "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response).to have_http_status(200)
      end
    end

    describe "Destroy" do 

      let(:user) { FactoryGirl.create :user } #destroy
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
       post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: FactoryGirl.build(:comment).attributes.symbolize_keys, format: :json
      end

      it "should delete the required comment" do
        delete "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response.body.empty?).to eql(true)
      end

      it "responds with 204" do
        delete "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response).to have_http_status(204)
      end

    end

    describe "Update" do 

      let(:user) { FactoryGirl.create :user } #update
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
        @comment = post "/api/v1/posts/#{@post.id}/comments?auth_token=#{user.authtokens.first.token}", comment: FactoryGirl.build(:comment).attributes.symbolize_keys, format: :json
      end

      context "with valid attributes" do
        it "should update the comment" do
          comment = FactoryGirl.attributes_for(:comment)
          comment[:text] = "asdfghj"
          put "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", comment: comment, format: :json
          @post.comments.last.reload 
          expect(@post.comments.last.text).to eq("asdfghj")
        end

        it 'responds with 200' do
          comment = FactoryGirl.attributes_for(:comment)
          comment[:text] = "asdfghj"
          put "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", comment: comment, format: :json
          @post.comments.last.reload 
          expect(response).to have_http_status(200)
        end
      end

      context 'with invalid attributes' do
        it 'does not update the comment' do
          comment = FactoryGirl.attributes_for(:comment)
          comment[:text] = ""
          put "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", comment: comment, format: :json
          @post.comments.last.reload 
          expect(@post.comments.last.text).not_to be_empty  
        end

        it 'responds with 422' do
          comment = FactoryGirl.attributes_for(:comment)
          comment[:text] = ""
          put "/api/v1/posts/#{@post.id}/comments/#{@post.comments.last.id}?auth_token=#{user.authtokens.first.token}", comment: comment, format: :json
          @post.comments.last.reload 
          expect(response).to have_http_status(422)
        end
      end

    end
  end



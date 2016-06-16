require 'rails_helper'

  context "json API" do

    describe "Create" do

      let(:user) { FactoryGirl.create :user } #create
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" } #create
      @post_params = FactoryGirl.build(:post, user: user).attributes
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
      end

      context "with valid attributes" do
        it "should create the post" do
          expect { post "/api/v1/posts?auth_token=#{user.authtokens.first.token}", post: @post_params, format: :json }.to change(Post, :count).by(1)
        end

        it 'responds with 201' do
          post "/api/v1/posts?auth_token=#{user.authtokens.first.token}", post: @post_params, format: :json
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
       
        it 'does not create the post' do
          post = FactoryGirl.build(:post).attributes.symbolize_keys
          post[:title] = ""
          expect { post "/api/v1/posts?auth_token=#{user.authtokens.first.token}", post: post, format: :json }.to_not change(Post, :count)
        end

        it 'responds with 422' do
          post = FactoryGirl.build(:post).attributes.symbolize_keys
          post[:title] = ""
          post "/api/v1/posts?auth_token=#{user.authtokens.first.token}",   post:   post, format: :json
          expect(response).to have_http_status(422)
        end
      end

    end  


    describe "Index" do 

      let(:user) { FactoryGirl.create :user } #index
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        3.times { FactoryGirl.create :post}
      end

      it "should fetch the correct number of posts" do
        get "/api/v1/posts?auth_token=#{user.authtokens.first.token}", page: 1, per: 2
        expect(json_response.count == 2).to eql(true)
      end

      it "should fetch the correct posts" do
        get "/api/v1/posts?auth_token=#{user.authtokens.first.token}", page: 1, per: 2
        json_response1 = json_response.clone
        get "/api/v1/posts?auth_token=#{user.authtokens.first.token}", page: 2, per: 2
        json_response2 = json_response.clone
        expect(json_response1.collect { |j1| j1['id'] } + json_response2.collect { |j2| j2['id'] }) .to eq(Post.all.collect(&:id))
      end
      
      it "responds with 200" do
        get "/api/v1/posts?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response).to have_http_status(200)
      end

    end

    describe "Show" do 

      let(:user) { FactoryGirl.create :user } #show
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
      end

      it "should fetch the required post" do
        get "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(json_response['id']).to eql(@post.id)
      end
      
      it "responds with 200" do
        get "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response).to have_http_status(200)
      end
    end

    describe "Destroy" do 

      let(:user) { FactoryGirl.create :user } #destroy
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
      end

      it "should delete the required post" do
        delete "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response.body.empty?).to eql(true)
      end

      it "responds with 204" do
        delete "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", format: :json
        expect(response).to have_http_status(204)
      end

    end

    describe "Update" do 

      let(:user) { FactoryGirl.create :user } #update
      before(:each) do
        headers = { "CONTENT_TYPE" => "application/json" }
        post "/login", '{ "user": { "email": "'+user.email+'", "password": "12345678" } }', headers
        @post = FactoryGirl.create :post
      end

      context "with valid attributes" do
        it "should update the post" do
          post = FactoryGirl.attributes_for(:post)
          post[:title] = "asdfghj"
          put "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", post: post, format: :json
          @post.reload
          expect(@post.title).to eq("asdfghj")
        end

        it 'responds with 200' do
          post = FactoryGirl.attributes_for(:post)
          post[:title] = "asdfghj"
          put "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", post: post, format: :json
          @post.reload
          expect(response).to have_http_status(200)
        end
      end

      context 'with invalid attributes' do

        it 'does not update the post' do
          post = FactoryGirl.attributes_for(:post)
          post[:title] = ""
          put "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", post: post, format: :json
          @post.reload
          expect(@post.title ).not_to be_empty  
        end

        it 'responds with 422' do
          post = FactoryGirl.attributes_for(:post)
          post[:title] = ""
          put "/api/v1/posts/#{@post.id}?auth_token=#{user.authtokens.first.token}", post: post, format: :json
          @post.reload
          expect(response).to have_http_status(422)
        end

      end

    end
  end



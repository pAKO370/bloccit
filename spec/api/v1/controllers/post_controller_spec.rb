require 'rails_helper'
include RandomData

RSpec.describe Api::V1::PostsController, type: :controller do 
  let(:my_user) { create(:user) }
  let(:my_topic) { create(:topic) }
  let(:my_post){create(:post, topic: my_topic, user: my_user)}

  before do
    3.times { create(:comment, post: my_post) }
    3.times { create(:vote, post: my_post) }
  end


  describe 'GET show' do
    before do
      get :show, id: my_post.id
      @parsed_response = JSON.parse(response.body)
    end

    it "returns http sucess" do
      expect(response).to have_http_status(:success)
    end

    it "returns the specified post" do
      expect(@parsed_response['id']).to eq(my_post.id)
      expect(@parsed_response['title']).to eq(my_post.title)
      expect(@parsed_response['body']).to eq(my_post.body)
    end

    it "returns the comments associated with the post" do
      expect(@parsed_response['comments'].size).to eq(my_post.comments.size)
      expect(@parsed_response['comments'].first['id']).to eq(my_post.comments.first.id)
    end

    it "return the votes associated with the post" do
      expect(@parsed_response['votes'].size).to eq(my_post.votes.size)
      expect(@parsed_response['votes'].first['id']).to eq(my_post.votes.first.id)
    end
  end




  context "unauthenticated user" do 
    it "GET index return http sucess" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "GET show return http sucess" do
      get :show, id: my_post.id
      expect(response).to have_http_status(:success)
    end
    it "PUT update returns http unauthenticated" do
      put :update, id: my_post.id, post: {title: "Post Name", body: "Post body"}
      expect(response).to have_http_status(401)
    end
 
    it "POST create returns http unauthenticated" do
      post :create, post: {title: "Post Name", body: "Post body"}
      expect(response).to have_http_status(401)
    end
 
    it "DELETE destroy returns http unauthenticated" do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(401)
    end
  end

  context "unauthorized user" do
    before do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
    end
 
 
    it "GET index returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
 
    it "GET show returns http success" do
      get :show, id: my_post.id
      expect(response).to have_http_status(:success)
    end
    it "PUT update returns http forbidden" do
      put :update, id: my_post.id, post: {title: "Post Name", body: "Post body"}
      expect(response).to have_http_status(403)
    end
 
    it "POST create returns http forbidden" do
      post :create, post: {title: "Post Name", body: "Post body"}
      expect(response).to have_http_status(403)
    end
 
    it "DELETE destroy returns http forbidden" do
      delete :destroy, id: my_post.id
      expect(response).to have_http_status(403)
    end
  end
  context "authenticated and authorized users" do

    before do
      my_user.admin!
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
      @new_post = build(:post)
    end
 
    describe "PUT update" do
      before { put :update, id: my_post.id, post: {title: @new_post.title, body: @new_post.body} }
 
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
 
      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end
 

      it "updates a post with the correct attributes" do
        updated_post = Post.find(my_post.id)
        expect(updated_post.title).to eq @new_post.title
        expect(updated_post.body).to eq @new_post.body
      end
    end
 
  describe "POST create" do
      before { post :create,topic_id: my_topic.id, post: {title: @new_post.title, body: @new_post.body} }
 
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
 
      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end

      it "creates a post with the correct attributes" do
        last_post = Post.last
        expect(last_post.title).to eq(@new_post.title)
        expect(last_post.body).to eq(@new_post.body)
      end
 
      it "returns a post with the correct attributes" do
        hashed_json = JSON.parse(response.body)
        expect(@new_post.title).to eq hashed_json["title"]
        expect(@new_post.body).to eq hashed_json["body"]
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, id: my_post.id }
 

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
 
      it "returns json content type" do
        expect(response.content_type).to eq 'application/json'
      end
 
      it "returns the correct json success message" do
        expect(response.body).to eq({"message" => "Post destroyed","status" => 200}.to_json)
      end
 
      it "deletes my_post" do

        expect{ Post.find(my_post.id) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
  



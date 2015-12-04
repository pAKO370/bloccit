require 'rails_helper'
include RandomData

RSpec.describe SponsoredPostController, type: :controller do

  let (:my_topic) { Topic.create!(name:  RandomData.random_sentence, description: RandomData.random_paragraph) }
 
  let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph) }
  

  describe "GET #show" do
    it "returns http success" do
      get :show, topic_id: my_topic.id, id: my_sponsoredpost.id

      expect(response).to have_http_status(:success)
    end
    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_sponsoredpost.id
      expect(response).to render_template :show
  end
  it "assigns my_post to @post" do
    get :show, topic_id: my_topic.id, id: my_sponsoredpost.id
    expect(assigns(:sponsoredpost)).to eq(my_sponsoredpost)
  end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

end

require 'rails_helper'
include SessionsHelper

describe TopicsController do
  context 'signed in as a moderator' do
    let(:original_topic) { Topic.create!(name: 'original', description: 'origin', public: true) }
    let(:moderator) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld", role: :moderator) }
    before { create_session(moderator) }

    describe 'PUT update' do
      it "successfully updates the specified topic with the specified attribtues" do
        put :update, id: original_topic.id, topic: {name: 'changed'}
        updated_topic = Topic.find(original_topic.id)
        expect(updated_topic.name).to eq('changed')
      end

      it "redirects to the topic" do
        put :update, id: original_topic.id, topic: {name: 'changed'}
        expect(response).to redirect_to(original_topic)
      end
    end

    describe 'GET edit' do
      it "render edit view" do
        get :edit, id: original_topic.id
        expect(response).to render_template(:edit)
      end

      it "assigns the @topic instance variable to the  specified topic" do
        get :edit, id: original_topic.id
        expect(assigns(:topic)).to eq(original_topic)
      end
    end

    describe 'POST create' do
      it 'does not create a new topic' do
        original_count = Topic.count
        post :create, topic: {name: 'new', description: 'new'}
        expect(Topic.count).to eq(original_count)
      end
    end
  end
end

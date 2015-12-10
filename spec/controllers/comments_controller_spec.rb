require 'rails_helper'

include RandomData
 include SessionsHelper

 RSpec.describe CommentsController, type: :controller do
   let(:my_user) { User.create!(name: "Bloccit User", email: "user@bloccit.com", password: "helloworld") }
   let(:other_user) { User.create!(name: RandomData.random_name, email: RandomData.random_email, password: "helloworld", role: :member) }
   let(:my_topic) { Topic.create!(name:  RandomData.random_sentence, description: RandomData.random_paragraph) }
   let(:my_post) { my_topic.posts.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, user: my_user) }
   let(:my_comment) { Comment.create!(body: 'Comment Body', post: my_post, user: my_user) }
 
 # #6
   context "guest" do
     describe "POST create" do
       it "redirects the user to the sign in view" do
         post :create, post_id: my_post.id, comment: {title: RandomData.random_sentence, body: RandomData.random_paragraph}
         expect(response).to redirect_to(new_session_path)
       end
     end
 
     describe "DELETE destroy" do
       it "redirects the user to the sign in view" do
         delete :destroy, post_id: my_post.id, id: my_comment.id
         expect(response).to redirect_to(new_session_path)
       end
     end
   end
 
 # #7
   context "member user doing CRUD on a comment they don't own" do
     before do
       create_session(other_user)
     end
 
     describe "POST create" do
       it "increases the number of comments by 1" do
         expect{ post :create, post_id: my_post.id, comment: {body: RandomData.random_sentence} }.to change(Comment,:count).by(1)
       end
 
       it "redirects to the post show view" do
         post :create, post_id: my_post.id, comment: {body: RandomData.random_sentence}
         expect(response).to redirect_to [my_topic, my_post]
       end
     end
 
     describe "DELETE destroy" do
       it "redirects the user to the posts show view" do
         delete :destroy, post_id: my_post.id, id: my_comment.id
         expect(response).to redirect_to([my_topic, my_post])
       end
     end
   end
 
 
 # #8
   context "member user doing CRUD on a comment they own" do
     before do
       create_session(my_user)
     end
 
     describe "POST create" do
       it "increases the number of comments by 1" do
         expect{ post :create, post_id: my_post.id, comment: {body: RandomData.random_sentence} }.to change(Comment,:count).by(1)
       end
 
       it "redirects to the post show view" do
         post :create, post_id: my_post.id, comment: {body: RandomData.random_sentence}
         expect(response).to redirect_to [my_topic, my_post]
       end
     end
 
     describe "DELETE destroy" do
       it "deletes the comment" do
         delete :destroy, post_id: my_post.id, id: my_comment.id
         count = Comment.where({id: my_comment.id}).count
         expect(count).to eq 0
       end
 
       it "redirects to the post show view" do
         delete :destroy, post_id: my_post.id, id: my_comment.id
         expect(response).to redirect_to [my_topic, my_post]
       end
     end
   end
 
 # #9
   context "admin user doing CRUD on a comment they don't own" do
     before do
       other_user.admin!
       create_session(other_user)
     end
 
     describe "POST create" do
       it "increases the number of comments by 1" do
         expect{ post :create, post_id: my_post.id, comment: {body: RandomData.random_sentence} }.to change(Comment,:count).by(1)
       end
 
       it "redirects to the post show view" do
         post :create, post_id: my_post.id, comment: {body: RandomData.random_sentence}
         expect(response).to redirect_to [my_topic, my_post]
       end
     end
 
     describe "DELETE destroy" do
       it "deletes the comment" do
         delete :destroy, post_id: my_post.id, id: my_comment.id
         count = Comment.where({id: my_comment.id}).count
         expect(count).to eq 0
       end
 
       it "redirects to the post show view" do
         delete :destroy, post_id: my_post.id, id: my_comment.id
         expect(response).to redirect_to [my_topic, my_post]
       end
     end
   end
   describe "after_create" do
 # #22
     before do
       @another_comment = Comment.new(body: 'Comment Body', post: post, user: user)
     end
 
 # #23
     it "sends an email to users who have favorited the post" do
       favorite = user.favorites.create(post: post)
       expect(FavoriteMailer).to receive(:new_comment).with(user, post, @another_comment).and_return(double(deliver_now: true))
 
       @another_comment.save
     end
 
 # #24
     it "does not send emails to users who haven't favorited the post" do
       expect(FavoriteMailer).not_to receive(:new_comment)
 
       @another_comment.save
     end
   end
end

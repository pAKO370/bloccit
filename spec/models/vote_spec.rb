require 'rails_helper'
include RandomData

RSpec.describe Vote, type: :model do
  
  let(:vote) { create(:vote, post: my_post) }
  let(:my_post) { create(:post)}
  
   it { should belong_to(:post) }
   it { should belong_to(:user) }
   it { should validate_presence_of(:value) }
   it { should validate_inclusion_of(:value).in_array([-1, 1]) }


   describe "update_post callback" do
     it "triggers update_post on save" do
 # #26
       expect(vote).to receive(:update_post).at_least(:once)
       vote.save
     end
 
     it "#update_post should call update_rank on post " do
 # #27
       expect(my_post).to receive(:update_rank).at_least(:once)
       vote.save
     end
   end
end

 include RandomData
 
 # #17
 FactoryGirl.define do
   factory :comment do
     body RandomData.random_paragraph
     post
     user
   end
 end
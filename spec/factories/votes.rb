 include RandomData
 
 # #17
 FactoryGirl.define do
   factory :vote do
     post
     user
     value 1
   end
 end
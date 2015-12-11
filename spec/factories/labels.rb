include RandomData
 
 # #17
 FactoryGirl.define do
   factory :label do
     name { RandomData.random_word }
      
    
   end
 end
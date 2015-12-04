include RandomData


 15.times do
   Topic.create!(
     name:         RandomData.random_sentence,
     description:  RandomData.random_paragraph
   )
 end
 topics = Topic.all

50.times do 

  Post.create!(

    topic:  topics.sample,
    title: RandomData.random_sentence,
    body: RandomData.random_paragraph
    )
end

posts = Post.all

  100.times do
   Comment.create!(
  
    post: posts.sample,
    body: RandomData.random_paragraph
    )
    end
    sponsored_posts = SponsoredPost.all

  10.times do
   SponsoredPost.create!(
  
    title: posts.sample,
    body: RandomData.random_paragraph,
    price: 99
    )
    end

    puts "Seed fininshed"
    puts "#{Topic.count} topics were created"
    puts "#{Post.count} posts created"
    puts "#{Comment.count} comments created"
    puts "#{SponsoredPost.count} sponsored posts created"
    

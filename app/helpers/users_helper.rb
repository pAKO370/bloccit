module UsersHelper

  def posts_heading_for_user(user)
    if user.posts.count == 0
      content_tag(:h4, 
        "#{@user.name} doesn't have any posts.")
    else
        
      end
    end
    
 

 
  def comments_heading_for_user(user)
    if user.comments.count == 0
      content_tag(:h4, 
        "#{@user.name} doesn't have any posts.")
    else
        
      end
    end

    def favorited_posts(user)
      @user.favorites.map {|favorite| favorite.post }
        
      
    end
  
end

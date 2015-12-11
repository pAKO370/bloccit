module UsersHelper

  def posts_heading_for_user(user)
    if user.posts.count == 0
      "#{@user.name} doesnt have any posts."
    else
      content_tag :h2 do
        "Posts:"
      end
    end
  end
end
 
  def no_comment?(comment)
    if current_user == current_user.comments
     
    end
  end
  
end

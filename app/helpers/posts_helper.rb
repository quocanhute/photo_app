module PostsHelper

  def label_styles(post, user, type)
    case type
    when 'upvote'
      if user.voted_up_on? post, vote_scope: "like"
        "fa-bounce text-info"
      else
        "text-dark"
      end
    when 'downvote'
      if user.voted_down_on? post, vote_scope: "like"
        "fa-bounce text-danger"
      else
        "text-dark"
      end
    end
  end

  def score_type(user, post)
    if user.voted_up_on? post, vote_scope: "like"
      "text-info"
    elsif user.voted_down_on? post, vote_scope: "like"
      "text-danger"
    else
      "text-dark"
    end
  end

  def label_styles_bookmark(post, user)
    if user.voted_up_on? post, vote_scope: "bookmark"
      "text-warning"
    else
      "text-dark"
    end
  end
end

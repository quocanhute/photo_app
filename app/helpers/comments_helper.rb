module CommentsHelper

  def label_comment_styles(comment, user, type)
    case type
    when 'upvote'
      if user.voted_up_on? comment, vote_scope: "like"
        "text-info"
      else
        "text-dark"
      end
    when 'downvote'
      if user.voted_down_on? comment, vote_scope: "like"
        "text-danger"
      else
        "text-dark"
      end
    end
  end

  def score_type(user, comment)
    if user.voted_up_on? comment, vote_scope: "like"
      "text-info"
    elsif user.voted_down_on? comment, vote_scope: "like"
      "text-danger"
    else
      "text-dark"
    end
  end

end

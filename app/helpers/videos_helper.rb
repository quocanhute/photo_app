module VideosHelper

  def video_label_styles(video, user, type)
    case type
    when 'upvote'
      if user.voted_up_on? video, vote_scope: "like"
        "fa-bounce text-info"
      else
        "text-dark"
      end
    when 'downvote'
      if user.voted_down_on? video, vote_scope: "like"
        "fa-bounce text-danger"
      else
        "text-dark"
      end
    end
  end

  def video_score_type(user, video)
    if user.voted_up_on? video, vote_scope: "like"
      "text-info"
    elsif user.voted_down_on? video, vote_scope: "like"
      "text-danger"
    else
      "text-dark"
    end
  end

  def video_label_styles_bookmark(video, user)
    if user.voted_up_on? video, vote_scope: "bookmark"
      "text-warning"
    else
      "text-dark"
    end
  end
end

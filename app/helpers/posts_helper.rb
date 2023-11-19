module PostsHelper
  def upvote_label(post, user)
    label_text = if user.voted_up_on? post, vote_scope: "like"
                   "UNvote"
                 else
                   "UPvote"
                 end
    tag.span do
      "#{post.cached_scoped_like_votes_up} #{label_text}"
    end
  end

  def downvote_label(post, user)
    label_text = if user.voted_down_on? post, vote_scope: "like"
                  "UNvote"
                else
                  "DOWNvote"
                 end
    tag.span do
      "#{post.cached_scoped_like_votes_down} #{label_text}"
    end
  end

  def upvote_label_styles(post, user)
    if user.voted_up_on? post, vote_scope: "like"
      "background-color: grey;"
    end
  end

  def downvote_label_styles(post, user)
    if user.voted_down_on? post, vote_scope: "like"
      "background-color: grey;"
    end
  end
end

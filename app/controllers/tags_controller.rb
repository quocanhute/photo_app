class TagsController < ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy added_tag]
  def index
    @tags = Tag.left_joins(:taggings).group(:id, :name, :detail).order('count(taggings.id) desc')
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html {
          flash[:notice] = 'Tag was successfully updated.'
          redirect_to tag_path(@tag)
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def added_tag
    current_user.add_tag(@tag)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: private_stream_tag
      end
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:detail, :tag_image)
  end

  def private_stream_tag
    private_target = "#{helpers.dom_id(@tag)} private_added_tag"
    turbo_stream.replace(private_target,
                         partial: 'tags/added_button',
                         locals:{
                           tag: @tag,
                           added_status: current_user.tag_added?(@tag)
                         })
  end
end
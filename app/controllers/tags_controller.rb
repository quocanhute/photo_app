class TagsController < ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy ]
  def index
    @tags = Tag.all
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

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:detail, :tag_image)
  end
end
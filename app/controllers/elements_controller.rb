class ElementsController < ApplicationController
  before_action :set_post
  before_action :set_element, only: %i[ show edit update destroy ]

  # GET /elements or /elements.json
  def index
    @elements = Element.all
  end

  # GET /elements/1 or /elements/1.json
  def show
  end

  # GET /elements/new
  def new
    @element = Element.new
  end

  # GET /elements/1/edit
  def edit
  end

  # POST /elements or /elements.json
  def create
    @element = @post.elements.build(element_params)

    respond_to do |format|
      if @element.save
        format.html {
          flash[:notice] = 'Element was successfully created.'
          redirect_to edit_post_path(@post)
        }
      else
        format.html { redirect_to edit_post_path(@post), notice: @element.errors.full_messages.join(". ") << "." }
      end
    end
  end

  # PATCH/PUT /elements/1 or /elements/1.json
  def update
    respond_to do |format|
      if @element.update(element_params)
        format.html {
          flash[:notice] = 'Paragraph was successfully updated.'
          redirect_to edit_post_path(@element.post)
        }
      else
        format.html { redirect_to edit_post_path(@element.post), status: :unprocessable_entity }
      end
    end
  end

  # DELETE /elements/1 or /elements/1.json
  def destroy
    @element.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = 'Paragraph was successfully destroyed.'
        redirect_to edit_post_path(@element.post)
      }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_post
    @post = current_user.posts.find(params[:post_id])
  end

  def set_element
    @element = @post.elements.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def element_params
    params.require(:element).permit(:element_type, :content, :image)
  end
end

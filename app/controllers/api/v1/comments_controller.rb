class Api::V1::CommentsController < Api::V1::BaseController
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  def index
    @post = Post.find(params[:post_id]) #Get the post object
    @comments = @post.comments.page(params[:page]).per(params[:per])

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @post = Post.find(params[:post_id]) #Get the post
    @comment = @post.comments.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @post.comments.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @post.comments.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
       params.require(:comment).permit()
    end
end

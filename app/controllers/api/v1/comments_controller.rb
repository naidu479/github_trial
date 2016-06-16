class Api::V1::CommentsController < Api::V1::BaseController
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  def index
    @post = Post.find(params[:post_id]) #Get the post object
    @comments = policy_scope(@post.comments).page(params[:page]).per(params[:per])

    render json: @comments
  end

  # GET /comments/1
  def show
    authorize @comment
    render json: @comment
  end

  # POST /comments
  def create
    @post = Post.find(params[:post_id]) #Get the post
    @comment = @post.comments.new(permitted_attributes(Comment.new))
    authorize @comment #Authorizing

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    authorize @comment
    if @post.comments.update(permitted_attributes(@comment))
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    authorize @comment
    @post.comments.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @post = Post.find(params[:post_id])
      @comment = @post.comments.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
end

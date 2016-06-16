class Api::V1::PostsController < Api::V1::BaseController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = policy_scope(Post).page(params[:page]).per(params[:per])

    render json: @posts
  end

  # GET /posts/1
  def show
    authorize @post
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(permitted_attributes(Post.new))
    authorize @post #Authorizing

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    authorize @post
    if @post.update(permitted_attributes(@post))
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    authorize @post
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
end

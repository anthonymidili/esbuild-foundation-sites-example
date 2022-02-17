class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.order(created_at: :desc)
    @post = Post.new
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @posts = Post.all

    respond_to do |format|
      if @post.save
        format.turbo_stream  do
          render turbo_stream:
          [
            turbo_stream.replace("form_new_post", partial: "posts/form", locals: { post: Post.new }),
            turbo_stream.prepend('posts', partial: "posts/post", locals: { post: @post })
          ]
        end
        format.html { redirect_to posts_url, notice: "Post was successfully created." }
        format.json { render :index, status: :created, location: posts_url }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("form_new_post", partial: "posts/form", locals: { post: @post })
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :index, status: :ok, location: posts_url }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("form_post_#{@post.id}", partial: 'posts/form', locals: { post: @post })
        end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :published)
    end
end
class PostsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

 # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all.order(:cached_votes_up => :desc)
    @posts_by_month = Post.all.group_by { |post| post.created_at.strftime("%B %Y") }
    @posts_by_day = Post.all.group_by { |post| post.created_at.strftime("%D %Y") }
    @post = Post.new
    @category = Post.where(category_id: @category_id)
  end

  # GET /post/1
  # GET /post/1.json
  def show
  end

  # GET /posts/new
  def new
  @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to :back, notice: 'post was successfully created.' }
        format.json { render :index, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end  

  def upvote
    	@post.upvote_from current_user
    	redirect_to posts_path
    end
    
    def downvote
    	@post.downvote_from current_user
    	redirect_to posts_path
    end
   def set_post
      @post = Post.find(params[:id])
    end
  private
     # Use callbacks to share common setup or constraints between actions.
 
    def post_params
      params.require(:post).permit(:attachment, :content, :user_id, :category_id)
    end
    
#upvoate from the user
#down vote from the user
end


class PostsController < ApplicationController
  before_action :set_place, only: [:new, :create]
  before_action :set_post, only: [:show]

  def index
    @posts = Post.all
  end

  def new
    @post = @place.posts.build
  end

  def create
    @post = @place.posts.build(post_params)
    @post.user = current_user

    if @post.save
      create_video if params.dig(:post, :video).present?
      redirect_to @place, notice: 'Post created successfully.'
    else
      render :new
    end
  end

  def show
    @comments = @post.comments
  end

  def next_batch
    last_post_id = params[:after_id]
    @posts = Post.where("id > ? AND place_id = ?", last_post_id, params[:place_id]).limit(5)
    render partial: "posts/next_batch", layout: false
  end

  def create_video
    video_file = params[:post][:video]
    cloudinary_response = Cloudinary::Uploader.upload(video_file.tempfile)
    @post.video_url = cloudinary_response['secure_url']
    @post.video_public_id = cloudinary_response['public_id']
    @post.save
  end

  private

  def post_params
    params.require(:post).permit(:place_rating, :video)
  end

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

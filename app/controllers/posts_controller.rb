class PostsController < ApplicationController
  def new
    @post = Post.destroy_all
    #@post = Post.new
    @post = Post.create(card_info: "S1 S2 S3 S4 S5")
  end

  def create
    #@post = Post.create(card_info: "S1 S2 S3 S4 S5")
    @post = Post.create(post_params)
    #役の判定しようね
    redirect_to("/show")
  end

  def show
    @post = Post.second
  end



  private
  def post_params
    params.require(:post).permit(:card_info)
  end
end


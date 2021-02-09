class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def result
    @post = Post.new(post_params)
  end





  private
  def post_params
    params.require(:post).permit(:card_info)
  end
end


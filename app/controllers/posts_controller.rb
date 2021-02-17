class PostsController < ApplicationController
  include PokerHands

  def new
    @post = Post.new(card_info: "S1 S2 S3 S4 S5")
    @post.valid?
  end

  def result
    @post = Post.new(post_params)
    @post.valid?
    poker(@post)
  end

  private
   def post_params
     params.require(:post).permit(:card_info)
   end
end


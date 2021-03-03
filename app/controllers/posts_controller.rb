class PostsController < ApplicationController
  include HandCommon
  protect_from_forgery

  def new
    @post = Post.new
  end

  def result
    @post = Post.new(post_params)
    @post.valid?
    card = @post.card_info
    @hand = HandCommon.hand_common(card)
  end

  private
  # ポーカーの役を判定するのに必要なcard_infoのみを受け取ることを許可している
  # セキュリティ強化のためのメソッド
  def post_params
    params.require(:post).permit(:card_info)
  end
end


class PostsController < ApplicationController
  def new
    #@post = Post.destroy_all
    @post = Post.new
    #@post = Post.new(card_info: "S1 S2 S3 S4 S5")
    #@n = 0
  end

  def create
    #@post = Post.create(card_info: "S1 S2 S3 S4 S5")
    #@post = Post.create(post_params)
    @post = Post.new(post_params)
    #if @post.find(1)
    #@post.find(1).destroy
    #end
    #@n += 1
    #役の判定しようね
    redirect_to("/show")
  end

  def show
    @post = params[:card_info]
  end



  private
  def post_params
    params.require(:post).permit(:card_info)
  end
end


class PokersController < ApplicationController
  include HandCommon
  protect_from_forgery

  def new
    @poker = Poker.new
  end

  def result
    @poker = Poker.new(poker_params)
    @poker.valid?
    card = @poker.card_info
    @hand = HandCommon.hand_common(card)
  end

  private
  # ポーカーの役を判定するのに必要なcard_infoのみを受け取ることを許可している
  # セキュリティ強化のためのメソッド
  def poker_params
    params.require(:poker).permit(:card_info)
  end
end


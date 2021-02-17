class PokerForm
  include ActiveModel::Model

  attr_accessor :card_info

  validates_presence_of :card_info

  def save
    return false if invalid?
    # 保存, 通知, ロギング等
    true
  end
end

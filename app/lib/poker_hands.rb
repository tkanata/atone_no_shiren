module PokerHands
  include HandCommon

  # web appとAPIで入力が異なるので、それぞれに合わせたメソッドを用意する
  # 具体的には、web appからの入力にはハッシュのキーを指定する必要がある
  # APIの場合は配列の要素が入力されるのでキーの情報は必要ない
  # そのため、web appの場合のみ、.card_info といった記述が必要になる

  ##############################################
  # web app用の判定メソッド
  def poker_web(input)
    # cardをweb appとAPIの共通処理メソッドに渡す
    return HandCommon.hand_common(input)

  end

  ########################################
  # API用の役判定メソッド
  def self.poker_api(card)

    # numをweb appとAPIの共通処理メソッドに渡す
    return HandCommon.hand_common(card)

  end
end

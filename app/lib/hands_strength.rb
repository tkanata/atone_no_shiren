module HandsStrength
  include HandCommon

  ################################################################################################
  # APIに入力された複数の5枚組のカード情報から役の強さを判定するメソッド
  # 出力は card, hand, best をキーとしたハッシュとする
  ################################################################################################

  def self.hands(cards_arr)
    # 役の名前(文字列)を配列に格納
    each_hand = cards_arr.map { |cards| HandCommon.hand_common(cards) }

    # 入力されたカードの組とその役をハッシュに変換している(keyがカード、valueが役)
    each_hand_hash = cards_arr.zip(each_hand).to_h

    # 役の強さはそれぞれに割り振った数字で管理する
    strength = {
      Settings.HANDS_STRENGTH.STRAIGHT_FLASH => ENV['STRAIGHT_FLASH'],
      Settings.HANDS_STRENGTH.FOUR_OF_A_KIND => ENV['FOUR_OF_A_KIND'],
      Settings.HANDS_STRENGTH.FULL_HOUSE => ENV['FULL_HOUSE'],
      Settings.HANDS_STRENGTH.FLASH => ENV['FLASH'],
      Settings.HANDS_STRENGTH.STRAIGHT => ENV['STRAIGHT'],
      Settings.HANDS_STRENGTH.THREE_OF_A_KIND => ENV['THREE_OF_A_KIND'],
      Settings.HANDS_STRENGTH.TWO_PAIR => ENV['TWO_PAIR'],
      Settings.HANDS_STRENGTH.ONE_PAIR => ENV['ONE_PAIR'],
      Settings.HANDS_STRENGTH.HIGH_CARD => ENV['HIGH_CARD']
    }
    strength.class

    # 入力されたカードの役と上記の数字を紐付け。配列の左から数字が大きい順に並ぶ。
    strength_key_sort = each_hand_hash.map { |_, value| strength.key(value) }.sort.reverse

    # 最も強い役は0番目に格納されている
    strongest_hand = strength[strength_key_sort[0]]

    # 最も強い役を持つカードの組を入力と役のハッシュから探し出す
    strongest_cards = each_hand_hash.key(strongest_hand)

    # 入力されたカードの組が最も強い役を持つかどうかを判定する
    strongest_boolean = cards_arr.map { |cards| cards == strongest_cards ? 'true' : 'false' }

    # 入力されたカードの '組'、'役'、'最強かどうかの真理値' を配列に格納する
    input_hand_strongest = cards_arr.zip(each_hand, strongest_boolean)

    # 上記の配列をハッシュに変換して戻り値とする
    input_hand_strongest.map do |input_hash|
      %w[card hand best].zip(input_hash).to_h
    end
  end

  ################################################################################################
  # self.hands(cards_arr)の出力とエラーメッセージを含むデータをAPIの出力用ハッシュに整えるメソッド
  ################################################################################################

  def self.output_api(params)
    errors = params.map do |each_card|
      b = Poker.new(card_info: each_card)
      b.validate
      b.errors.full_messages.join("\n")
    end

    # カード情報とエラーメッセージの紐付け
    cards_errors_arr = params.zip(errors)

    # エラーが出ないと空の要素が配列に残るので、それを消している
    cards_errors_arr.delete_if do |_, error|
      error.empty?
    end

    # エラーの配列から'card'と'msg'をキーとするハッシュを作っている
    cards_errors_hash = cards_errors_arr.map do |each_pair|
      %w[card msg].zip(each_pair).to_h
    end

    valid_params = params.delete_if do |param|
      Poker.new(card_info: param).validate == false
    end

    result = HandsStrength.hands(valid_params)

    # 以下のハッシュを戻り値とする
    if cards_errors_hash.empty?
      { result: result }
    else
      {
        result: result,
        error: cards_errors_hash
      }
    end
  end
end

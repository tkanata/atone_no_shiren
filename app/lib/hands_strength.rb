module HandsStrength
  include PokerHands

  # APIに入力された複数の5枚組のカード情報から役の強さを判定するメソッド
  # 入力はAPIにおいてparams[:cards]として取得された、配列を想定
  # 出力は card, hand, best をキーとしたハッシュとする

  def self.hands(cards_arr)

    each_hand = cards_arr.map { |cards|
      PokerHands.poker_api(cards)
    }

    # 入力されたカードの組とその役をハッシュに変換している(keyがカード、valueが役)
    each_hand_hash = cards_arr.zip(each_hand).to_h

    # 役の強さはそれぞれに割り振った数字で管理する
    strength = {
      9 => "ストレートフラッシュ",
      8 => "フォー・オブ・ア・カインド",
      7 => "フルハウス",
      6 => "フラッシュ",
      5 => "ストレート",
      4 => "スリー・オブ・ア・カインド",
      3 => "ツーペア",
      2 => "ワンペア",
      1 => "ハイカード",
    }
    strength.class

    strength_key = each_hand_hash.map{ |key, each_hand|
      strength.key(each_hand)
    }

    # 役の強さを表す数字が格納された配列内を数字の大きさで並べ替え
    strength_key_sort = strength_key.sort.reverse

    # 最も強い役を数字と役のハッシュから探し出す
    strongest_hand = strength[strength_key_sort[0]]

    # 最も強い役を持つカードの組を入力と役のハッシュから探し出す
    @strongest_cards = each_hand_hash.key(strongest_hand)

    # 入力されたカードの組が最も強い役を持つかどうかを判定する
    strongest_boolean = cards_arr.map { |cards|
      if cards == @strongest_cards
        cards = "true"
      else
        cards = "false"
      end
    }

    # 入力されたカードの組、役、最強かどうかの真理値を配列に格納する
    input_hand_strongest = cards_arr.zip(each_hand, strongest_boolean)

    @input_hand_strongest_hash = input_hand_strongest.map do |input_hash|
        a = ["card", "hand", "best"]
        a.zip(input_hash).to_h
    end

    return @input_hand_strongest_hash
  end

  # self.hands(cards_arr)の出力とエラーメッセージを含むデータをAPIの出力用ハッシュに整えるメソッド
  ######################################
  def self.output_api(params)
    errors = params.map do |each_card|
      b = Post.new(card_info: each_card)
      b.validate
      errors_arr = b.errors.full_messages
      # エラーメッセージは配列に格納されている。今回は1つしかメッセージが出ないので、0番目の要素のみを取り出している
      errors_arr[0]
    end

    # カード情報とエラーメッセージの紐付け
    cards_errors_arr = params.zip(errors)

    # エラーが出ないと空の要素が配列に残るので、それを消している
    cards_errors_arr.delete_if do |key, error|
      error.nil?
    end

    # エラーの配列から"card"と"msg"をキーとするハッシュを作っている
    cards_errors_hash = cards_errors_arr.map do |each_pair|
      name = ["card", "msg"]
      name.zip(each_pair).to_h
    end

    valid_params = params.delete_if do |param|
      Post.new(card_info: param).validate == false
    end

    result = HandsStrength.hands(valid_params)

    # 表示する結果は以下のハッシュ
    unless cards_errors_hash.empty?
      return @hash = {
        result: result,
        error: cards_errors_hash,
      }
    else
      return @hash = { result: result }
    end
  end
end
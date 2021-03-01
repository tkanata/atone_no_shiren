module PokerHands
  # web appとAPIで入力が異なるので、それぞれに合わせたメソッドを用意する
  # 具体的には、web appからの入力にはハッシュのキーを指定する必要がある
  # APIの場合は配列の要素が入力されるのでキーの情報は必要ない
  # そのため、web appの場合のみ、.card_info といった記述が必要になる

  # web app用の判定メソッド
  def poker_web(card)
    #フラッシュ、ストレートフラッシュ、ストレートの判定
    # スートの判定プログラム
    # scanメソッドでH, S, C, D を取得。配列で返す
    heart = card.card_info.scan("H")
    club = card.card_info.scan("C")
    spade = card.card_info.scan("S")
    dia = card.card_info.scan("D")

    # フラッシュの判定
    if heart.size == 5 || club.size ==5 || spade.size == 5 || dia.size ==5
      @flash = 1
    end

    # 連番の判定
    num = card.card_info.scan(/\d+/)

    num = num.sort

    for n in 1..4 do
      if num[0].to_i + n != num[n].to_i
        @notice = "not straight or flash"
        break
      else
        #puts "#{num}"
        @notice = "straight"
      end
    end

    # ストレートフラッシュ、ストレート、フラッシュの判定
    if @notice == "straight" and @flash == 1
      @hand = "ストレートフラッシュ"
    elsif @notice == "straight"
      @hand = "ストレート"
    elsif @flash == 1
      @hand = "フラッシュ"
    else
      @hand = nil
    end

    #ストレートフラッシュ、フラッシュ、ストレートのいずれかならば、@handを返して終了する
    if @hand != nil
      return @hand
    end

    #フラッシュ系、ストレート系以外の役の判定
    # 数字の重複の判定
    # 整数化
    num = card.card_info.scan(/\d+/)
    num = num.sort
    num = num.map!(&:to_i)

    # numをweb appとAPIの共通処理メソッドに渡す
    return HandCommon.hand_common(num)

  end



  ########################################
  # API用の役判定メソッド
  def self.poker_api(card)
    include HandCommon

    @flash = nil

    #フラッシュ、ストレートフラッシュ、ストレートの判定
    # スートの判定プログラム
    # scanメソッドでH, S, C, D を取得。配列で返す
    heart = card.scan("H")
    club = card.scan("C")
    spade = card.scan("S")
    dia = card.scan("D")

    # フラッシュの判定
    if heart.size == 5 || club.size ==5 || spade.size == 5 || dia.size ==5
      @flash = 1
    end

    # 連番の判定
    num = card.scan(/\d+/)

    num = num.sort

    for n in 1..4 do
      if num[0].to_i + n != num[n].to_i
        @notice = "not straight or flash"
        break
      else
        #puts "#{num}"
        @notice = "straight"
      end
    end

    # ストレートフラッシュ、ストレート、フラッシュの判定
    if @notice == "straight" and @flash == 1
      @hand = "ストレートフラッシュ"
    elsif @notice == "straight"
      @hand = "ストレート"
    elsif @flash == 1
      @hand = "フラッシュ"
    else
      @hand = nil
    end

    #ストレートフラッシュ、フラッシュ、ストレートのいずれかならば、@handを返して終了する
    if @hand != nil
      return @hand
    end

    #フラッシュ系、ストレート系以外の役の判定
    # 数字の重複の判定
    # 整数化
    num = card.scan(/\d+/)
    num = num.sort
    num = num.map!(&:to_i)

    # numをweb appとAPIの共通処理メソッドに渡す
    return HandCommon.hand_common(num)

  end
end


module HandsStrength
  include PokerHands

  # APIに入力された複数の5枚組のカード情報から役の強さを判定するメソッド
  # 入力はAPIにおいてparams[:cards]として取得された、配列を想定
  # 出力は card, hand, best をキーとしたハッシュとする
  def self.hands(cards_arr)
    # 配列を引数とする
    # PokerHandsモジュールのpoker_apiメソッドで役を判定。@each_handに格納

    # 結果は配列に格納したいので、mapメソッドを用いる
    each_hand = cards_arr.map { |cards|
      PokerHands.poker_api(cards)
    }

    # 入力されたカードの組とその役をハッシュに変換している(keyがカード、valueが役)
    each_hand_hash = cards_arr.zip(each_hand).to_h

    # 役の強さはそれぞれに割り振った数字で管理する
    # 以下はハッシュの宣言
    strength = {
      9 => "ストレートフラッシュ",
      8 => "フォー・オブ・ア・カインド",
      7 => "フルハウス",
      6 => "フラッシュ",
      5 => "ストレート",
      4 => "スリー・オブ・ア・カインド",
      3 => "ツーペア",
      2 => "ワンペア",
      1 => "ハイカード"
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
      return @hash = {result: result, error: cards_errors_hash}
    else
      return @hash = {result: result}
    end
  end
end
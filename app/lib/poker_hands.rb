module PokerHands
  include HandCommon

  # web appとAPIで入力が異なるので、それぞれに合わせたメソッドを用意する
  # 具体的には、web appからの入力にはハッシュのキーを指定する必要がある
  # APIの場合は配列の要素が入力されるのでキーの情報は必要ない
  # そのため、web appの場合のみ、.card_info といった記述が必要になる

  ##############################################
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
    num = card.card_info.scan(/\d+/).sort

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

    # 数字の重複の判定
    num = card.card_info.scan(/\d+/).sort.map!(&:to_i)

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
    num = card.scan(/\d+/).sort

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

    # 数字の重複の判定
    num = card.scan(/\d+/).sort.map!(&:to_i)

    # numをweb appとAPIの共通処理メソッドに渡す
    return HandCommon.hand_common(num)

  end
end
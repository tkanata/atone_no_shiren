require 'rails_helper'

include HandCommon
include HandsStrength

RSpec.describe 'HandsStrength' do

  # APIからの入力からポーカーの役を判定するメソッドのテスト
  describe 'self.common(card)' do
    context 'when input is valid' do
      it 'returns ストレートフラッシュ' do
        input = 'S1 S2 S3 S4 S5'
        expect(HandCommon.hand_common(input)).to eq('ストレートフラッシュ')
      end
      it 'returns フラッシュ' do
        input = 'S1 S2 S3 S4 S9'
        expect(HandCommon.hand_common(input)).to eq('フラッシュ')
      end
      it 'returns ストレート' do
        input = 'D1 H2 C3 S4 D5'
        expect(HandCommon.hand_common(input)).to eq('ストレート')
      end
      it 'returns フォー・オブ・ア・カインド' do
        input = 'S1 D9 H9 C9 S9'
        expect(HandCommon.hand_common(input)).to eq('フォー・オブ・ア・カインド')
      end
      it 'returns フルハウス' do
        input = 'S1 D1 H9 C9 S9'
        expect(HandCommon.hand_common(input)).to eq('フルハウス')
      end
      it 'returns スリー・オブ・ア・カインド' do
        input = 'S1 D12 H9 C9 S9'
        expect(HandCommon.hand_common(input)).to eq('スリー・オブ・ア・カインド')
      end
      it 'returns ツーペア' do
        input = 'S1 D1 H9 C9 S13'
        expect(HandCommon.hand_common(input)).to eq('ツーペア')
      end
      it 'returns ワンペア' do
        input = 'S1 D1 H11 C5 S8'
        expect(HandCommon.hand_common(input)).to eq('ワンペア')
      end
      it 'returns ハイカード' do
        input = 'S12 D4 H7 C9 S13'
        expect(HandCommon.hand_common(input)).to eq('ハイカード')
      end
    end

    # context 'when input is empty' do
    # it ''
    # end

  end

  # APIに入力された複数の5枚組のカード情報から役の強さを判定するメソッドのテスト
  describe 'self.hands(cards_arr)' do
    context 'when input is valid' do
      it 'returns an array including some hashes with three keys :card, :hand, :best' do
        input = ['H1 H13 H12 H11 H10', 'S1 H1 D1 S4 H4', 'S12 D12 H5 C1 S10']
        expect(HandsStrength.hands(input)).to eq(
                                                [
                                                  {
                                                    'card' => 'H1 H13 H12 H11 H10',
                                                    'hand' => 'フラッシュ',
                                                    'best' => 'false'
                                                  },
                                                 {
                                                    'card' => 'S1 H1 D1 S4 H4',
                                                    'hand' => 'フルハウス',
                                                    'best' => 'true'
                                                  },
                                                 {
                                                    'card' => 'S12 D12 H5 C1 S10',
                                                    'hand' => 'ワンペア',
                                                    'best' => 'false'
                                                  },
                                                ]
                                              )
      end
    end
    # 不正な入力は入力前のバリデーションで弾かれるので、self.output_api(params)のテストで確認を行う
  end


  # self.hands(cards_arr)の出力とエラーメッセージを含むデータをAPIの出力用ハッシュに整えるメソッド
  # self.hands(cards_arr)への入力のバリデーションを行っている
  describe 'self.output_api(params)' do
    context 'when input is valid' do
      it 'returns {:result => HandsStrength.hands(input)} without any error message' do
        params = ['S1 H1 D1 S4 H4', 'S12 D12 H5 C1 S10', 'S12 D12 H5 C1 S10']
        expect(HandsStrength.output_api(params)).to eq(
                                                      {
                                                        :result => HandsStrength.hands(params)
                                                      }
                                                    )
      end
    end

    context 'when one or more input is invalid' do
      it 'returns result with valid input and error message with invalid input' do
        params = ['S1 H1 D1 S4 H4', '', 'S12 D12 H5 C1S10']
        valid_params = ['S1 H1 D1 S4 H4']
        expect(HandsStrength.output_api(params)).to eq(
                                                      {
                                                        # 有効なカード情報の結果のみが表示される
                                                        :result => HandsStrength.hands(valid_params),

                                                        # 無効なカード情報に関するエラーが表示される
                                                        :error => [
                                                          {
                                                            'card' => '',
                                                            'msg' => '値を入力してください'
                                                          },
                                                          {
                                                            'card' => 'S12 D12 H5 C1S10',
                                                            'msg' => '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
                                                          },
                                                        ]
                                                      }
                                                    )
      end
    end
  end

end

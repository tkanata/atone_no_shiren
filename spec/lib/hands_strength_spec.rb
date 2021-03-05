require 'rails_helper'

include HandCommon
include HandsStrength

RSpec.describe 'HandsStrength' do

  # APIに入力された複数の5枚組のカード情報から役の強さを判定するメソッドのテスト
  describe 'self.hands(cards_arr)' do
    context 'when input is valid' do
      it 'returns an array including some hashes with three keys :card, :hand, :best' do
        input = ['H1 H13 H12 H11 H10', 'S1 H1 D1 S4 H4', 'S12 D12 H5 C1 S10']
        expect(HandsStrength.hands(input)).to eq(
                                                [
                                                  {
                                                    'card' => 'H1 H13 H12 H11 H10',
                                                    'hand' => ENV['FLASH'],
                                                    'best' => 'false'
                                                  },
                                                 {
                                                    'card' => 'S1 H1 D1 S4 H4',
                                                    'hand' => ENV['FULL_HOUSE'],
                                                    'best' => 'true'
                                                  },
                                                 {
                                                    'card' => 'S12 D12 H5 C1 S10',
                                                    'hand' => ENV['ONE_PAIR'],
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
        params = ['S1 H1 D1 S4 H4', 'S12 D12 H5 C1 S10', 'S11 D12 H5 C1 S10']
        expect(HandsStrength.output_api(params)).to eq(
                                                      {
                                                        :result => [
                                                          {
                                                            'card'=> 'S1 H1 D1 S4 H4',
                                                            'hand'=> ENV['FULL_HOUSE'],
                                                            'best'=> 'true'
                                                          },
                                                          {
                                                            'card'=> 'S12 D12 H5 C1 S10',
                                                            'hand'=> ENV['ONE_PAIR'],
                                                            'best'=> 'false'
                                                          },
                                                          {
                                                            'card'=> 'S11 D12 H5 C1 S10',
                                                            'hand'=> ENV['HIGH_CARD'],
                                                            'best'=> 'false'
                                                          }
                                                        ]
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
                                                        :result => [
                                                          {
                                                            'card' => 'S1 H1 D1 S4 H4',
                                                            'hand' => ENV['FULL_HOUSE'],
                                                            'best' => 'true'
                                                          }
                                                        ],

                                                        # 無効なカード情報に関するエラーが表示される
                                                        :error => [
                                                          {
                                                            'card' => '',
                                                            'msg' => '値を入力してください。'
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

require 'rails_helper'

RSpec.describe 'Posts', type: :request do

  describe 'Post request' do
    context 'when input is valid' do
      it 'responds successfully' do
        post '/api/v1/cards', params: { cards: ['S1 H1 D1 S4 H4', 'S12 D12 H5 C1 S10', 'S11 D12 H5 C1 S10'] }
        input = ['S1 H1 D1 S4 H4', 'S12 D12 H5 C1 S10', 'S11 D12 H5 C1 S10']
        expect(response.status).to eq(201)
        expect(HandsStrength.output_api(input)).to eq(
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

    # 入力値が空のカードを含んでいても、値は受け取られる
    # APIでは、全ての結果を出力形式にして返すメソッド内で行われるバリデーションが失敗したら、400を返すように記述してある
    context 'when input is invalid' do
      it 'does not respond successfully' do
        post '/api/v1/cards', params: { poker: ['S1 H1 D1 S4 H4', '', 'S12 D12 H5 C1S10'] }
        input = ['S1 H1 D1 S4 H4', '', 'S12 D12 H5 C1S10']
        expect(response.status).to eq(400)
        expect(
          HandsStrength.output_api(input)
        ).to eq(
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
                     'msg' => Settings.ERROR_MESSAGE.EMPTY
                   },
                   {
                     'card' => 'S12 D12 H5 C1S10',
                     'msg' => Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE + "\n4枚目のカード情報が適切ではありません。(C1S10)\n" + Settings.ERROR_MESSAGE.VALID_SUIT_NUM
                   },
                 ]
               }
             )
      end
    end

  end

end

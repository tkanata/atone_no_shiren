require 'rails_helper'

RSpec.describe PokersController, type: :controller do

  # newアクションが適切に応答しているかどうかのテスト
  describe 'new' do
    it 'responds successfully' do
      get :new
      expect(response).to be_successful
    end
  end

  # resultアクションにおいてカード情報を更新できるかどうかのテスト
  # 入力が不正だとしても、バリデーションはモデルの仕事なので値は@pokerに保持される

  describe 'result' do
    context 'when @poker receives valid card information from a form' do

      it 'adds a card information to @poker' do
        post :result, params: {poker: {card_info: 'H1 H2 H3 H4 H5'}}
        expect(controller.instance_variable_get('@poker').card_info).to eq 'H1 H2 H3 H4 H5'
      end

    end

    context 'when @poker receives invalid card information from a form' do

      it 'adds a card information to @poker' do
        post :result, params: {poker: {card_info: 'H1 H2 H3 H4'}}
        expect(controller.instance_variable_get('@poker').card_info).to eq 'H1 H2 H3 H4'
        expect(
          controller.instance_variable_get('@poker').errors.full_messages.join("\n")
        ).to eq Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE
      end

    end

  end
end

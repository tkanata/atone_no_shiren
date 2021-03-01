require 'rails_helper'

RSpec.describe "Posts", type: :request do

  describe "Post request" do
    context "when input is valid" do
      it "responds successfully" do
        post "/api/v1/cards", params: { cards: ["H1 H13 H12 H11 H10", "S1 H1 D1 S4 H4", "S1 S2 S3 S4 S5"] }
        expect(response.status).to eq(201)
      end
    end

    # 入力値が空のカードを含んでいても、値は受け取られる
    # APIでは、全ての結果を出力形式にして返すメソッド内で行われるバリデーションが失敗したら、400を返すように記述してある
    context "when input is invalid" do
      it "does not respond successfully" do
        post "/api/v1/cards", params: { poker: ["S1 S2 S3 S4 S5", "S1 H1 D1 S4 H4", "S1 S2 S3 S4 S5"] }
        expect(response.status).to eq(400)
      end
    end

  end

end

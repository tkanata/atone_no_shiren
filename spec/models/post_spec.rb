require 'rails_helper'

RSpec.describe Post, type: :model do
  it "gets a card information" do
    post = build(:post)
    expect(post).to be_valid
  end
end

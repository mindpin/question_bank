require 'rails_helper'

RSpec.describe DemoQuestion, type: :model do
  it { is_expected.to validate_presence_of(:subject)}

  it "属性" do
    @demo_question = create(:demo_question)
    expect(@demo_question.respond_to?(:subject)).to be true
  end
end


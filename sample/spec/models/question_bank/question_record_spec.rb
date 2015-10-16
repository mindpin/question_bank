require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "基础字段" do
    it{
      @question_record = create(:question_record)
      expect(@question_record.respond_to?(:question_id)).to eq(true)
      expect(@question_record.respond_to?(:user_id)).to eq(true)
      expect(@question_record.respond_to?(:is_correct)).to eq(true)
      expect(@question_record.respond_to?(:bool_answer)).to eq(true)
      expect(@question_record.respond_to?(:choice_answer)).to eq(true)
      expect(@question_record.respond_to?(:essay_answer)).to eq(true)
      expect(@question_record.respond_to?(:fill_answer)).to eq(true)
      expect(@question_record.respond_to?(:mapping_answer)).to eq(true)
    }
  end
end
require 'rails_helper'
RSpec.describe QuestionBank::QuestionFlaw, type: :model do
  describe 'UserMethods' do
    before :example do
      @user = create(:user)
      @bool_question = create(:bool_question)
    end

    describe 'user.add_flaw_question(question)' do
      it{
        before_add_count = @user.question_flaws.count
        @user.add_flaw_question(@bool_question)
        after_add_count = @user.question_flaws.count
        expect(@user.question_flaws.first.question.content).to eq(@bool_question.content)
        expect(before_add_count+1).to eq(after_add_count)
        expect(@user.question_flaws.count).to eq(1)
        expect(QuestionBank::QuestionFlaw.where(:user => @user,:question => @bool_question).first.present?).to eq(true)
      }
    end

    describe 'user.remove_flaw_question(question)' do
      it{
        @user.add_flaw_question(@bool_question)
        @user.remove_flaw_question(@bool_question)
        expect(@user.flaw_questions.count).to eq(0)
        expect(QuestionBank::QuestionFlaw.where(:user => @user,:question => @bool_question).first.present?).to eq(false)
      }
    end

    describe 'question.is_in_flaw_list_of?(user)' do
      it{
        QuestionBank::QuestionFlaw.create(:user => @user,:question => @bool_question)
        expect(@bool_question.is_in_flaw_list_of?(@user)).to eq(true)
      }
    end

    # 测试冗余字段
    describe '冗余字段' do
      it{
        flaw = QuestionBank::QuestionFlaw.create(:user => @user,:question => @bool_question)
        expect(flaw.kind).to eq(@bool_question.kind)
      }
    end
    # 测试方法
    describe 'user.flaw_questions' do
      it{
        @bool_question = create(:bool_question)
        @choice_question = create(:single_choice_question)
        before_add_2_question_count = @user.flaw_questions.count
        @user.add_flaw_question(@bool_question)
        @user.add_flaw_question(@choice_question)
        after_add_2_question_count = @user.flaw_questions.count
        expect(@user.flaw_questions.where(:kind => "single_choice").first.content).to eq(@choice_question.content)
        expect(@user.flaw_questions.where(:kind => "bool").first.content).to eq(@bool_question.content)
        expect(before_add_2_question_count+2).to eq(after_add_2_question_count)
      }
    end
  end

  describe "测试 with_created_at 方法" do
    describe "成功" do
      it{
        QuestionBank::QuestionFlaw.destroy_all
        @user = create :user
        @question1 = create :essay_question
        @question2 = create :single_choice_question
        @question3 = create :multi_choice_question

        @day_1 = Time.local(2015, 12, 01, 10, 0, 0)
        @day_2 = Time.local(2015, 12, 02, 10, 0, 0)
        @day_3 = Time.local(2015, 12, 06, 10, 0, 0)
        @day_4 = Time.local(2015, 12, 07, 10, 0, 0)

        arrays = [
          [@question1,@day_1,'day_1'],
          [@question2,@day_2,'day_2'],
          [@question3,@day_3,'day_3']
        ]
        add_flaw_hashs = {}
        arrays.each do |question|
          Timecop.freeze(question[1]) do
            @flaw = @user.add_flaw_question(question[0])
            add_flaw_hashs["#{question[2]}_flaw"] = @flaw
          end
        end
        query_hash = {:start_time => @day_1-1.minute,:end_time =>@day_2-1.minute}
        flaws = QuestionBank::QuestionFlaw.with_created_at(query_hash)
        expect(flaws.count).to eq(1)
        expect(flaws.where(:created_at => @day_1).first).to eq(add_flaw_hashs["day_1_flaw"])
        query_hash = {:start_time => @day_1-1.minute,:end_time =>@day_4-1.minute}
        flaws = QuestionBank::QuestionFlaw.with_created_at(query_hash)
        expect(flaws.count).to eq(3)
        expect(flaws.where(:created_at=>@day_1).first).to eq(add_flaw_hashs["day_1_flaw"])
        expect(flaws.where(:created_at=>@day_2).first).to eq(add_flaw_hashs["day_2_flaw"])
        expect(flaws.where(:created_at=>@day_3).first).to eq(add_flaw_hashs["day_3_flaw"])
      }
    end

    describe "失败" do
      it{
        @start_time = nil
        @end_time   = nil
        @batch_search = QuestionBank::QuestionFlaw.with_created_at({:start_time => @start_time, :end_time => @end_time})
        expect(@batch_search.count).to eq(0)
      }
    end
  end

  describe "测试 with_kind 方法" do
    before :example do
      @user     = create :user
    end

    describe "kind 为 bool" do
      it{
        @question = create :bool_question
        @flaw = @question.question_flaws.create(
          :user => @user
        )
        expect(@flaw.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionFlaw.with_kind("bool")
        expect(@kind_search.first).to eq(@flaw)
      }
    end

    describe "kind 为 single_choice" do
      it{
        @question = create :single_choice_question
        @flaw = @question.question_flaws.create(
          :user => @user
        )
        expect(@flaw.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionFlaw.with_kind("single_choice")
        expect(@kind_search.first).to eq(@flaw)
      }
    end

    describe "kind 为 multi_choice" do
      it{
        @question = create :multi_choice_question
        @flaw = @question.question_flaws.create(
          :user => @user
        )
        expect(@flaw.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionFlaw.with_kind("multi_choice")
        expect(@kind_search.first).to eq(@flaw)
      }
    end

    describe "kind 为 fill" do
      it{
        @question = create :fill_question
        @flaw = @question.question_flaws.create(
          :user => @user
        )
        expect(@flaw.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionFlaw.with_kind("fill")
        expect(@kind_search.first).to eq(@flaw)
      }
    end

    describe "kind 为 mapping" do
      it{
        @question = create :mapping_question
        @flaw = @question.question_flaws.create(
          :user => @user
        )
        expect(@flaw.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionFlaw.with_kind("mapping")
        expect(@kind_search.first).to eq(@flaw)
      }
    end

    describe "kind 为 essay" do
      it{
        @question = create :essay_question
        @flaw = @question.question_flaws.create(
          :user => @user
        )
        expect(@flaw.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionFlaw.with_kind("essay")
        expect(@kind_search.first).to eq(@flaw)
      }
    end
  end
end

require 'rails_helper'

RSpec.describe QuestionBank::QuestionRecord, type: :model do
  describe "单选题" do
    before :all do
      @question = create :single_choice_question
      @user     = create(:user)
    end

    describe "回答正确" do
      before :all do
        @record = @question.question_records.create(
          :user          => @user,
          :answer        => "ddd"
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct?).to eq(true)
      }

      it{
        expect(@record.answer).to eq("ddd")
      }
    end

    describe "回答错误" do
      before :context do
        @record = @question.question_records.create(
          :user   => @user,
          :answer => "aaa"
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct?).to eq(false)
      }

      it{
        expect(@record.answer).to eq("aaa")
      }
    end

    describe "答案格式不正确" do
      before :all do
        @choice_answers = [
          "5",
          true,
          ["5"],
          {"5" => true}
        ]
      end

      it{
        @choice_answers.each do |answer|
          record = @question.question_records.create(
            :user   => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:answer]).not_to be_nil
        end
      }
    end
  end

  describe "多选题" do
    before :all do
      @question = create :multi_choice_question
      @user     = create(:user)
    end

    describe "回答正确" do
      before :all do
        @record = @question.question_records.create(
          :user   => @user,
          :answer => ["ccc", "bbb","ddd","eee"]
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.answer).to match_array(["bbb","ccc","ddd","eee"])
      }
    end

    describe "回答错误" do
      before :all do
        @record = @question.question_records.create(
          :user   => @user,
          :answer => ["bbb","ccc"]
        )
      end
      it{
        expect(@record.valid?).to eq(true)
      }
      it{
        expect(@record.kind).to eq(@question.kind)
      }
      it{
        expect(@record.is_correct).to eq(false)
      }
      it{
        expect(@record.answer).to eq(["bbb","ccc"])
      }
    end

    describe "答案格式不正确" do
      it{
        choice_answer = [
          "adfsdf",
          ["asdfsf"],
          {"0" => ["leg"]}
        ]
        choice_answer.each do |answer|
          record = @question.question_records.create(
            :user  => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:answer]).not_to be_nil
        end
      }
    end
  end

  describe "填空题" do
    before :all do
      @question = create :fill_question
      @user     = create(:user)
    end

    describe "回答正确" do
      before :all do
        @fill_answer = ["北京", "伦敦"]
        @record      = @question.question_records.create(
          :user   => @user,
          :answer => @fill_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.answer).to eq(@fill_answer)
      }
    end

    describe "回答错误" do
      before :all do
        @fill_answer = ["上海", "苏格兰"]
        @record      = @question.question_records.create(
          :user   => @user,
          :answer => @fill_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.answer).to eq(@fill_answer)
      }
    end

    describe "答案格式不正确" do
      it{
        fill_answers = [
          "123",
          ["1"],
          [true,1452],
          [["北京"],["伦敦"]]
        ]
        fill_answers.each do |answer|
          record = @question.question_records.create(
            :user => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:answer]).not_to be_nil
        end
      }
    end
  end

  describe "连线题" do
    before :all do
      @question = create :mapping_question
      @user = create(:user)
    end

    describe "回答正确" do
      before :all do
        @mapping_answer = [
          {
            "left"  => "bbb",
            "right" => "fff"
          },
          {
            "right" => "eee",
            "left"  => "aaa"
          },
          {
            "left"  => "ccc",
            "right" => "ddd"
          }
        ]
        @record = @question.question_records.create(
          :user => @user,
          :answer => @mapping_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.answer).to eq(@mapping_answer)
      }
    end

    describe "回答错误" do
      before :all do
        @mapping_answer = [
          {
            "left"  => "aaa",
            "right" => "fff"
          },
          {
            "left"  => "bbb",
            "right" => "eee"
          },
          {
            "left"  => "ccc",
            "right" => "ddd"
          }
        ]
        @record = @question.question_records.create(
          :user => @user,
          :answer => @mapping_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.answer).to eq(@mapping_answer)
      }
    end

    describe "答案格式不正确" do
      it{
        mapping_answer = [
          "123",
          {"0" => ["hello"]},
          [
            {
              "left"  => "aaa",
              "right" => "eee"
            },
            {
              "left"  => "bbb",
              "right" => "eee"
            },
            {
              "left"  => "ccc",
              "right" => "ddd"
            }
          ]
        ]
        mapping_answer.each do |answer|
          record = @question.question_records.create(
            :user => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:answer]).not_to be_nil
        end
      }
    end
  end

  describe "论述题" do
    before :all do
      @question = create :essay_question
      @user = create(:user)
    end

    describe "回答正确" do
      before :all do
        @essay_answer = "很关键"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @essay_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.answer).to eq(@essay_answer)
      }
    end

    describe "回答错误" do
      before :all do
        @essay_answer = "I don't know"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @essay_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.answer).to eq(@essay_answer)
      }
    end

    describe "答案格式不正确" do
      it{
        answers = [
          ["123"],
          {"0" => ["hello"]}
        ]
        answers.each do |answer|
          record = @question.question_records.create(
            :user => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:answer]).not_to be_nil
        end
      }
    end

  end

  describe "判断题" do
    before :all do
      @question = create :bool_question
      @user = create(:user)
    end

    describe "回答正确" do
      before :all do
        @bool_answer = "true"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @bool_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(true)
      }

      it{
        expect(@record.answer).to eq(true)
      }
    end

    describe "回答错误" do
      before :all do
        @bool_answer = "false"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @bool_answer
        )
      end

      it{
        expect(@record.valid?).to eq(true)
      }

      it{
        expect(@record.kind).to eq(@question.kind)
      }

      it{
        expect(@record.is_correct).to eq(false)
      }

      it{
        expect(@record.answer).to eq(false)
      }
    end

    describe "答案格式不正确" do
      it{
        answers = [
          ["123"],
          {"0" => ["hello"]}
        ]
        answers.each do |answer|
          record = @question.question_records.create(
            :user => @user,
            :answer => answer
          )
          expect(record.valid?).to eq(false)
          expect(record.errors.messages[:answer]).not_to be_nil
        end
      }
    end

  end

  describe "测试 with_created_at 方法" do
    describe "成功" do
      it{
        @user = create :user
        QuestionBank::QuestionRecord.destroy_all
        @essay_question = create :essay_question
        @day_1 = Time.local(2015, 12, 01, 10, 0, 0)
        @day_2 = Time.local(2015, 12, 02, 10, 0, 0)
        @day_3 = Time.local(2015, 12, 06, 10, 0, 0)
        @day_4 = Time.local(2015, 12, 07, 10, 0, 0)
        @day1_essay_answer = '2015-12-01-abc'
        @day2_essay_answer = '2015-12-02-def'
        @day3_essay_answer = '2015-12-06-ghi'
        @day4_essay_answer = '2015-12-07-jkl'

        arrays = [
          ['day_1',@day_1,@day1_essay_answer],
          ['day_2',@day_2,@day2_essay_answer],
          ['day_3',@day_3,@day3_essay_answer],
          ['day_4',@day_4,@day4_essay_answer]
        ]
        create_hashs = {}
        arrays.each do |item|
          Timecop.freeze(item[1]) do
            @record_day = @essay_question.question_records.create(
              :user => @user,
              :answer => item[2]
            )
            create_hashs["#{item[0]}_record"] = @record_day
          end
        end
        query_hash = {:start_time => @day_1-1.minute,:end_time => @day_2-1.minute}
        records = QuestionBank::QuestionRecord.with_created_at(query_hash)
        expect(records.count).to eq(1)
        expect(records.where(:created_at=>@day_1).first.answer).to eq(create_hashs["day_1_record"].answer)
        query_hash = {:start_time => @day_1-1.minute,:end_time => @day_4-1.minute}
        records = QuestionBank::QuestionRecord.with_created_at(query_hash)
        expect(records.count).to eq(3)
        expect(records.where(:created_at=>@day_1).first.answer).to eq(create_hashs["day_1_record"].answer)
        expect(records.where(:created_at=>@day_2).first.answer).to eq(create_hashs["day_2_record"].answer)
        expect(records.where(:created_at=>@day_3).first.answer).to eq(create_hashs["day_3_record"].answer)
      }
    end

    describe "失败" do
      it{
        @start_time = nil
        @end_time   = nil
        @batch_search = QuestionBank::QuestionRecord.with_created_at({:start_time => @start_time, :end_time => @end_time})
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
        @bool_answer = "false"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @bool_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("bool")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 single_choice" do
      it{
        @question = create :single_choice_question
        @choice_answer ="ddd"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @choice_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("single_choice")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 multi_choice" do
      it{
        @question = create :multi_choice_question
        @choice_answer = ["aaa","bbb"]
        @record = @question.question_records.create(
          :user => @user,
          :answer => @choice_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("multi_choice")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 fill" do
      it{
        @question = create :fill_question
        @fill_answer = ["北京", "伦敦"]
        @record = @question.question_records.create(
          :user => @user,
          :answer => @fill_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("fill")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 mapping" do
      it{
        @question = create :mapping_question
        @mapping_answer = [
          {
            "left"  => "aaa",
             "right" => "eee"
          },
          {
            "left"  => "bbb",
            "right" => "fff"
          },
          {
            "left"  => "ccc",
            "right" => "ddd"
          }
        ]
        @record = @question.question_records.create(
          :user => @user,
          :answer => @mapping_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("mapping")
        expect(@kind_search.first).to eq(@record)
      }
    end

    describe "kind 为 essay" do
      it{
        @question = create :essay_question
        @essay_answer = "很关键"
        @record = @question.question_records.create(
          :user => @user,
          :answer => @essay_answer
        )
        expect(@record.valid?).to eq(true)
        @kind_search = QuestionBank::QuestionRecord.with_kind("essay")
        expect(@kind_search.first).to eq(@record)
      }
    end
  end

  describe "测试 with_correct 方法" do
    before :example do
      @user     = create :user
      @question = create :bool_question
    end

    it{
      @bool_answers = [
        "false",
        "true"
      ]
      @bool_answers.each do |answer|
        record      = @question.question_records.create(
          :user   => @user,
          :answer => answer
        )
        expect(record.valid?).to eq(true)
        wheater_correct = QuestionBank::QuestionRecord.with_correct(answer)
        expect(wheater_correct.first).to eq(record)
      end
    }
  end
end

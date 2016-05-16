FactoryGirl.define do
  factory :section, class: QuestionBank::Section do
    kind :single_choice
    score 5
    min_level 1
    max_level 10
  end

  factory :single_choice_section, class: QuestionBank::Section do
    kind :single_choice
    score 5
    min_level 1
    max_level 10

    after(:create) do |section|
      list = create_list(:single_choice_question, 5)
      section.questions = list
      section.save
    end
  end

  factory :test_paper, class: QuestionBank::TestPaper do
    sequence(:title){|n| "试卷#{n}"}
    score 100
    minutes 60

    factory :test_paper_with_questions do
      after(:create) do |test_paper|
        create(:single_choice_section, test_paper: test_paper)
      end
    end

  end
end

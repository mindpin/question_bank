module QuestionBank
  class QuestionFlawController < QuestionBank::ApplicationController
    def index
      @question_flaw = QuestionBank::QuestionFlaw.all
    end
  end
end
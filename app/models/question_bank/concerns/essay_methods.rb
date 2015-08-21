p "reload EssayMethods"
module QuestionBank
  module EssayMethods
    extend ActiveSupport::Concern

    included do
      ## 论述题答案
      field :essay_answer, :type => String
      ##

      scope :essay, -> { where(kind: "essay") }
    end

    module ClassMethods
    end

  end
end

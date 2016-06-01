module QuestionBank
  class Point
    # 知识点
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,  type: String

    has_and_belongs_to_many :questions, class_name: "QuestionBank::Question", inverse_of: :points

    validates :name,  presence: true

    module QuestionMethods
      extend ActiveSupport::Concern
      included do
        has_and_belongs_to_many :points, class_name: "QuestionBank::Question", inverse_of: :questions
        scope :with_point, ->(point_name) {
          id = QuestionBank::Point.where(:name.in => [point_name]).first.try(:id)
          where(:point_ids.in => [id])
        }
      end

      module ClassMethods
      end
    end
  end
end

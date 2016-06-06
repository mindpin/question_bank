module QuestionBank
  class Point
    # 知识点
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name,  type: String

    validates :name,  presence: true

    module QuestionMethods
      extend ActiveSupport::Concern
      included do
        has_and_belongs_to_many :points, class_name: "QuestionBank::Point", inverse_of: nil
        scope :with_point, ->(point_name) {
          id = QuestionBank::Point.where(:name => point_name).first.try(:id)
          where(:point_ids.in => [id])
        }
      end

      module ClassMethods
      end
    end
  end
end

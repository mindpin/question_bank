require 'rails_helper'

class MovePositionTestParent
  include Mongoid::Document
  has_many :tests, class_name: 'MovePositionTest'
end

class MovePositionTest
  include Mongoid::Document
  include QuestionBank::Concerns::MovePosition
  belongs_to :father, class_name: 'MovePositionTestParent'

  def parent
    father
  end
end

RSpec.describe QuestionBank::Concerns::MovePosition, type: :module do
  describe "基础字段" do
    it{
      @test = MovePositionTest.create
      expect(@test.respond_to? :position).to eq(true)
      expect(@test.respond_to? :prev).to eq(true)
      expect(@test.respond_to? :next).to eq(true)
      expect(@test.respond_to? :move_up).to eq(true)
      expect(@test.respond_to? :move_down).to eq(true)

      expect(@test.respond_to? :set_position).to eq(true)

      expect(@test.position).not_to be_nil
      expect(@test.position).to be > 0
    }
  end

  describe QuestionBank::Section, type: :model do
    before{
      @test_paper = create(:test_paper)
      @section1 = create(:section, test_paper: @test_paper, position: 1)
      @section2 = create(:section, test_paper: @test_paper, position: 2)
    }

    it{
      expect(@section1.prev).to eq(nil)
      expect(@section1.next).to eq(@section2)
      expect(@section2.prev).to eq(@section1)
      expect(@section2.next).to eq(nil)
    }

    it{
      expect(@section1.move_up).to be_nil
      expect(@section1.prev).to eq(nil)
      expect(@section1.next).to eq(@section2)
      expect(@section2.prev).to eq(@section1)
      expect(@section2.next).to eq(nil)
    }

    it{
      expect(@section1.move_down).not_to be_nil
      @section1.reload
      @section2.reload

      expect(@section1.prev).to eq(@section2)
      expect(@section1.next).to eq(nil)
      expect(@section2.prev).to eq(nil)
      expect(@section2.next).to eq(@section1)
    }
  end

end

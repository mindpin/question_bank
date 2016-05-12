class DemoQuestion < QuestionBank::Question
  # 科目：中文录入 数字录入 客户地址录入 交易码速记 翻打传票 票面计算 多行计算 会计分录 Excel Word 理论知识 业务仿真-单交易 业务仿真-按流程
  SUBJECTS = %w[chinese number address code summons face_cal multi_cal entries excel word theory sim_deal sim_process]

  enumerize :subject, in: SUBJECTS
  validates :subject, presence: true

  def self.subjects
    SUBJECTS
  end
end

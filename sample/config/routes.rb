Rails.application.routes.draw do
  mount QuestionBank::Engine => '/', :as => 'question_bank'
  mount PlayAuth::Engine => '/auth', :as => :auth
end

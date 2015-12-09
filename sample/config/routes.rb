Rails.application.routes.draw do
  QuestionBank::Routing.mount '/', :as => 'question_bank'
  mount PlayAuth::Engine => '/auth', :as => :auth
end

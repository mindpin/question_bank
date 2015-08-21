QuestionBank::Engine.routes.draw do
  root 'home#index'
  resources :questions do
    collection do
      get 'new_single_choice'
    end
  end
end
QuestionBank::Engine.routes.draw do
  root 'home#index'
  # get 'new_mapping' => 'questions#new_mapping'
  resources :questions do
    collection do
        get 'new_mapping'
    end
  end
end
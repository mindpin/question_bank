QuestionBank::Engine.routes.draw do
  root 'home#index'
  resources :questions do
    collection do
      get :new_bool
      get :new_single_choice
      get :new_mapping
      get :new_multi_choice
    end
  end
end

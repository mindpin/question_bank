QuestionBank::Engine.routes.draw do
  root 'home#index'
  resources :questions do
    member do
      get :redo_question
    end
    collection do
      get :new_bool
      get :new_single_choice
      get :new_mapping
      get :new_multi_choice
      get :new_essay
      get :new_fill
      get :search
      get :do_question
    end
    member do
      post :do_question_validation
    end     
  end

  resources :test_papers, shallow: true do
    post :preview, on: :collection
    resources :test_paper_results
  end

  resources :question_records do 
    delete :batch_destroy, on: :collection
  end

  resources :question_flaws do
    post :batch_create, on: :collection
    delete :batch_destroy, on: :collection
  end


end

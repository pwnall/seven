Seven::Application.routes.draw do
  authpwn_session

  resources :courses
  resources :prerequisites

  # Registration
  resources :users do
    collection do
      get :lookup
      post :check_email
    end
    member do
      post :impersonate
      put :set_admin
      put :confirm_email
    end
  end
  resources :profiles, :only => [] do
    collection do
      post :websis_lookup
      put :websis_lookup
    end
  end
  resources :profile_photos do
    member do
      get :profile, :thumb
    end
  end  
  resources :registrations
  resources :recitation_sections

  # Homework.
  resources :assignments
  resources :grades do
    collection do
      get :editor
      get :request_report, :request_missing
      post :for_user, :missing, :report
    end
    member do
      put :update_for_user
    end
  end

  # Homework submission.
  resources :analyzers, :only => [] do
    member do
      get :source
    end
  end
  resources :deliverables
  resources :assignment_metrics
  resources :submissions do
    member do
      get :file
      get :info
      post :revalidate
    end
    collection do
      get :request_package
      post :xhr_deliverables
      post :package_assignment
    end
  end
  resources :analyses
  
  # Surveys.
  resources :survey_questions
  resources :surveys do
    member do
      post :add_question
      delete :remove_question
    end
  end
  resources :survey_answers
  
  # Teams.
  resources :team_memberships
  resources :team_partitions
  resources :teams
  
  # Deprecated.
  resources :announcements  
  resource :api, :controller => 'api' do
    get :conflict_info
  end
  

  root :to => "session#show"
end

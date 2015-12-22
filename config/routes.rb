Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'jobs/index'

  root 'session#show'

  # Site-wide functionality.
  scope '/_' do
    authpwn_session
    resources :courses, only: [:index, :new, :create] do
      collection do
        get :connect
      end
    end

    # Account registration.
    resources :users do
      collection do
        post :check_email
      end
      member do
        post :impersonate
        patch :set_admin
        patch :confirm_email
      end
    end
    resources :profiles, only: [] do
      collection do
        post :websis_lookup
        patch :websis_lookup
      end
    end
    resources :profile_photos do
      member do
        get :profile, :thumb
      end
    end

    # Staff registration.
    resources :roles, only: [:destroy]

    # Background jobs.
    resources :jobs, only: [:index, :show] do
      collection do
        delete :failed, action: :destroy_failed
      end
    end

    # E-mail resolver configuration.
    resources :email_resolvers

    # E-mail SMTP server configuration.
    resource :smtp_server, only: [:edit, :update]

    # Exception handling test.
    get '/crash' => 'crash#crash'
  end

  # Course-specific URLs. Most functionality falls here.
  scope '/:id', constraints: { id: /[^\/]+/ } do
    get 'course(.:format)', to: 'courses#show', as: :course
    patch 'course(.:format)', to: 'courses#update'
    delete 'course(.:format)', to: 'courses#destroy'
    get 'course/edit(.:format)', to: 'courses#edit', as: :edit_course
  end

  scope '/:course_id', constraints: { course_id: /[^\/]+/ } do
    # TODO(pwnall): remove the format specifier when the following bug gets
    #               fixed - https://github.com/rails/rails/issues/22747
    root 'session#show', as: :course_root, format: 'html'

    resources :prerequisites, except: [:show]
    resources :time_slots, only: [:index, :create, :destroy]

    # Student registration.
    resources :registrations,
              only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch :restricted
      end
    end

    # Staff registration.
    resources :role_requests, only: [:index, :new, :create, :show, :destroy] do
      member do
        post :approve
        post :deny
      end
    end

    # Recitations.
    resources :recitation_sections, except: [:show] do
      collection do
        post :autoassign
      end
    end
    resources :recitation_partitions, only: [:index, :show, :destroy]  do
      member do
        post :implement
      end
    end

    # Homework.
    resources :assignments do
      member do
        get :dashboard
        patch :schedule
        patch :deschedule
        patch :release
        patch :unrelease
        patch :release_grades
      end
      resources :extensions, controller: :deadline_extensions,
          only: [:index, :create]
    end
    resources :deadline_extensions, only: [:destroy]
    resources :assignment_files, only: [] do
      member do
        get :download
      end
    end
    resources :grades, only: [:index, :create] do
      collection do
        get :editor
        get :request_report, :request_missing
        post :for_user, :missing, :report
      end
    end
    resources :grade_comments, only: [:create]
    resources :exam_sessions, only: [] do
      member do
        post :check_in
      end
    end

    # Homework submission.
    resources :analyzers, only: [] do
      collection do
        get :help
      end
      member do
        get :source
      end
    end
    resources :deliverables do
      member do
        get :submission_dashboard
        post :reanalyze
      end
    end
    resources :assignment_metrics
    resources :submissions, only: [:index, :create, :destroy] do
      member do
        get :file
        post :reanalyze
        post :promote
      end
      collection do
        get :request_package
        post :xhr_deliverables
        post :package_assignment
      end
      resources :collaborations, only: [:create, :destroy], shallow: true
    end
    resources :analyses, only: [:show] do
      member do
        get :refresh
      end
    end

    # Surveys.
    scope shallow_prefix: :survey do
      resources :surveys do
        resources :responses, controller: :survey_responses,
            only: [:index, :create, :update], shallow: true
      end
    end

    # Teams.
    resources :team_memberships, only: [:create, :destroy]
    resources :team_partitions do
      member do
        patch :lock
        patch :unlock
        get :issues
      end
    end

    resources :teams, only: [:edit, :create, :update, :destroy]
    # Teams / Student view.
    get '/teams_student', to: 'teams_student#show'
    post '/teams_student/leave_team', to: 'teams_student#leave_team', as: :leave_team
    post '/teams_student/create_team', to: 'teams_student#create_team'
    post '/teams_student/invite_member', to: 'teams_student#invite_member'
    post '/teams_student/accept_invitation', to: 'teams_student#accept_invitation'
    post '/teams_student/ignore_invitation', to: 'teams_student#ignore_invitation'
    resources :teams_student

    # Deprecated.
    resources :announcements
  end

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end

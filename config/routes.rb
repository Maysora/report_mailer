Rails.application.routes.draw do
  resources :report_mails do
    collection do
      get :monthly_summary
    end
    member do
      post :send_email
      post :duplicate
    end

    resources :report_mail_projects do
      member do
        post :duplicate
      end
    end
  end
  resources :report_mail_projects, only: [] do
    resources :report_mail_milestones, only: %i[index new create edit update destroy]
    resources :report_mail_tasks
  end
  resources :settings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

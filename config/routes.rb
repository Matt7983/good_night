Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :client_info, only: :index

  resources :users do
    post :follow, on: :member
    post :unfollow, on: :member

    get :followers_records, on: :member

    post 'clock_in', to: 'clocks#create'
    put 'clock_out', to: 'clocks#update'
  end
end

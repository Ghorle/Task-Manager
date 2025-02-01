Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, except: [:index, :show, :create, :update, :destroy] do
    collection do
      post :register, to: "users#register"
      post :login, to: "users#login"
    end
  end

  resources :tasks, only: [:index, :show, :create, :update, :destroy]
end

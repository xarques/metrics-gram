Rails.application.routes.draw do
  devise_for :users

  resources :locations, only: [:index, :show] do
  end

  resources :media, only: [:index, :show] do
    collection do
      get 'search', to: "media#search"
    end
    # member do
    #   patch 'search', to: "media#search"
    # end
  end

  root to: 'locations#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

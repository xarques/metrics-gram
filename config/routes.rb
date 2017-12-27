Rails.application.routes.draw do
  devise_for :users

  resources :locations, only: [:index] do
  end

  resources :accounts, only: [:index] do
    collection do
      get 'search', to: "accounts#search"
    end
  end

  resources :media, only: [] do
    collection do
      get 'search_by_tag', to: "media#search_by_tag"
      get 'index_by_tag', to: "media#index_by_tag"
    end
    # member do
    #   patch 'search', to: "media#search"
    # end
  end

  root to: 'accounts#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

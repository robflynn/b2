Rails.application.routes.draw do
  get '/status/(:name)', to: 'dashboard#show', constraints: { name: /[^\/]+/ }, as: :status
  get '/status/(:name)/uncrawled', to: 'dashboard#uncrawled', constraints: { name: /[^\/]+/ }
  get '/status/(:name)/tester', to: 'dashboard#tester', constraints: { name: /[^\/]+/ }
  get '/status/(:name)/videos', to: 'dashboard#videos', constraints: { name: /[^\/]+/ }, as: :videos

  resources :websites, only: [:index, :create] do
    member do
      get 'get_stats'
      get 'get_queue'

      post 'queue'
      patch 'update_page'
    end
  end
end

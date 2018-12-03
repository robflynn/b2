Rails.application.routes.draw do
    resources :websites, only: [:index, :create] do
        member do
            post 'queue'
        end
    end
end

Spree::Core::Engine.routes.append do

  namespace :admin do
    resources :products do
      resources :parts do
        collection do
          post :available
        end
      end
      resources :assemblies do
        resources :parts do
          member do
            post :remove
            post :set_count
          end
        end
      end
    end
  end

end

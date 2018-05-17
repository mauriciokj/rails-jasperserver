JasperserverRails::Engine.routes.draw do
  resources :details, only: :show do
    resources :downloads, only: :show
  end
end

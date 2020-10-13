Rails.application.routes.draw do
  root to: 'home#index'
  post 'import', to: 'home#import', as: 'import_products'
  namespace :api do
  	namespace :v1 do
  		get 'product' => 'api#products'
  		get 'article' => 'api#articles'
  		post 'url_paser', to: 'api#url_paser'
  	end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

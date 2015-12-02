Rails.application.routes.draw do
  
  resources :posts

  get 'about' => 'welcome#about'

 
  # get '/', to: 'welcome#index'
  root to: 'welcome#index'

end

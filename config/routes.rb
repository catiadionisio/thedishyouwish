Thedishyouwish::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations" }

  root to: 'public#index'
  get "ajax_receitas" => "public#ajax_receitas"
  get "receitas" => "public#receitas"
  get "ementa" => "public#ementa"
  get "sobre" => "public#sobre"
  get "ementa_diaria" => "public#ementa_diaria"
  get "perfil" => "perfil#perfil"
  get "perfil_ano" => "perfil#perfil_ano"
  get "perfil_mes" => "perfil#perfil_mes"
  get "receitas_favoritas" => "perfil#receitas"
  get "ementas_guardadas" => "perfil#ementas"
  get "ementa_perfil/:id" => "perfil#ementa_perfil"
  get "apagar_ementa/:id" => "perfil#apagar_ementa"
  get "receitas_actividade" => "perfil#receitas_actividade"
  get "restricoes" => "perfil#restricoes"
  post "add_restricao" => "perfil#add_restricao"
  get "remover_restricao" => "perfil#remover_restricao"
  get "receita/:id" => "public#receita"
  get "receita/lista_receita/:id" => "public#lista_receita"
  get "fav" => "user_receita#fav", :as => :favorite
  get "rating" => "ratings#rating", :as => :rating
  post "receita/salvar_comentario" => "public#save_comment"
  get "add_ementa" => "public#add_ementa", :as => :add_ementa
  get "ementa/guardar_ementa" => "public#guardar_ementa"
  get "ementa/reset" => "public#reset"
  get "ementa/prev_day" => "public#prev_day"
  get "ementa/next_day" => "public#next_day"
  get "ementa/nova_ementa" => "public#nova_ementa"
  get "ementa_delete" => "public#ementa_delete"
  get "ementa_delete_refeicao" => "public#ementa_delete_refeicao"
  get "add_ementa_refeicao" => "public#add_ementa_refeicao"
  get "ementa_extras" => "public#ementa_extras"
  get "ementa_lock" => "public#ementa_lock"
  get "ementa_pessoas" => "public#ementa_pessoas"
  get "receita_pessoas" => "public#receita_pessoas"
  get "ementa/gerar_ementa" => "public#gerar_ementa"
  get "ementa/lista_ementa" => "public#lista_ementa"
  get "ajuda" => "public#ajuda"

  get 'user_root' => 'perfil#perfil'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

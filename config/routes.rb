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
  get "ementa_perfil_cs/:id" => "perfil#ementa_perfil_cs"
  get "apagar_ementa/:id" => "perfil#apagar_ementa"
  get "vista_diaria/:id" => "perfil#vista_diaria"
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
  post "receitas_fav" => "public#receitas_fav"
  post "receitas_all" => "public#receitas_all"
  get "ajuda" => "public#ajuda"

  post "ee_receitas_fav" => "perfil#ee_receitas_fav"
  post "ee_receitas_all" => "perfil#ee_receitas_all"
  get "ee_ementa_diaria" => "perfil#ee_ementa_diaria"
  get "ementa_perfil/:id/ee_prev_day" => "perfil#ee_prev_day"
  get "ementa_perfil/:id/ee_next_day" => "perfil#ee_next_day"
  get "ee_add_ementa" => "perfil#ee_add_ementa"
  get "ee_add_ementa_refeicao" => "perfil#ee_add_ementa_refeicao"
  get "ementa_perfil/:id/ee_nova_ementa" => "perfil#ee_nova_ementa"
  get "ementa_perfil/:id/ee_reset" => "perfil#ee_reset"
  get "ee_ementa_delete" => "perfil#ee_ementa_delete"
  get "ee_ementa_delete_refeicao" => "perfil#ee_ementa_delete_refeicao"
  get "ee_ementa_extras" => "perfil#ee_ementa_extras"
  get "ee_ementa_lock" => "perfil#ee_ementa_lock"
  get "ee_ementa_pessoas" => "perfil#ee_ementa_pessoas"
  get "ee_guardar_ementa" => "perfil#ee_guardar_ementa"

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

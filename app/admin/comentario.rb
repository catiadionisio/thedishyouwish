#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Comentario do

  controller do
    def permitted_params
      params.permit comentario: [:conteudo, :nome, :user_id, :receita_id ]
    end
  end

  menu :label => "Comentários" 

  index :title => "Comentários" do
    selectable_column
    column :conteudo
    column :nome
    column "Data e Hora", :created_at
    actions :name => "Acções"
  end

  filter :user, label: 'Utilizador', :input_html => { :class => "chosen-select2" }
  filter :receita, label: 'Receitas', :input_html => { :class => "chosen-select2" }
  filter :conteudo, label: 'Conteúdo'
  filter :nome
  filter :created_at
  filter :updated_at

  show do |post|
    attributes_table do
      row :id
      row :nome
      row ('Utilizador') {post.user}
      row :receita
      row :conteudo
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Comentário" do
      f.input :nome
      f.input :user, :label => "Utilizador", :input_html => { :class => "chosen-select" }
      f.input :receita, :input_html => { :class => "chosen-select" }
      f.input :conteudo, :label => "Conteúdo" 
    end
    f.actions
  end
  
end
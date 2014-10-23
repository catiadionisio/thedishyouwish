#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Ingrediente do

  menu :label => "Ingredientes"

  permit_params :nome, :seccao_id, :peso_medio
  
  index :title => "Ingredientes" do
    selectable_column
    column :nome
    column "Secção", :seccao, :sortable => :seccao do |ingrediente|
      ingrediente.seccao.to_s
    end
    column "Peso médio (g)", :peso_medio
    actions :name => "Acções"
  end

  filter :seccao, label: 'Secção', :input_html => { :class => "chosen-select2" }
  filter :nome
  filter :peso_medio, label: 'Peso médio'
  filter :created_at
  filter :updated_at

  show do |post|
    attributes_table do
      row :id
      row :nome
      row ('Secção') {post.seccao}
      row ('Peso médio (g)') {post.peso_medio}
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs "Ingrediente" do
      f.input :nome
      f.input :seccao, :label => "Secção", :input_html => { :class => "chosen-select" }
      f.input :peso_medio, :label => "Peso médio (g)" 
    end
    f.actions
  end
  
end

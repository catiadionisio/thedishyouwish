#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Categoria do

  menu :label => "Categorias"

  permit_params :nome

  index :title => "Categorias" do
    selectable_column
    column :nome
    column :created_at
    actions :name => "Acções"
  end

  filter :nome
  filter :created_at

  form do |f|
    f.inputs "Categoria" do
      f.input :nome
    end
    f.actions
  end
  
end

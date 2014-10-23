#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Tiporefeicao do

  menu :label => "Tipo de refeição"

  permit_params :nome

  index :title => "Tipos de refeição" do
    selectable_column
    column :nome
    column :created_at
    actions :name => "Acções"
  end

  filter :nome
  filter :created_at

  form do |f|
    f.inputs "Tipo de refeição" do
      f.input :nome
    end
    f.actions
  end
  
end

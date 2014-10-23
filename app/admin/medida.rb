#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Medida do

  menu :label => "Medidas"

  permit_params :nome, :ml, :gr

  index :title => "Medidas" do
    selectable_column
    column :id
    column :nome
    column "Mililitros", :ml
    column "Gramas", :gr
    actions :name => "Acções"
  end

  filter :nome
  filter :ml
  filter :gr
  filter :created_at
  filter :updated_at
  
end

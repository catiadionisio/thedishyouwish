#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Seccao do

  menu :label => "Secções"
  permit_params :nome

  index :title => "Secções" do
    selectable_column
    column :nome
    column :created_at
    actions :name => "Acções"
  end

  filter :nome
  filter :created_at

  form do |f|
    f.inputs "Secção" do
      f.input :nome
    end
    f.actions
  end
  
end

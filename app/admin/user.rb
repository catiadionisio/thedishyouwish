#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register User do

  menu :label => "Utilizadores"

  permit_params :email, :nome, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :nome
    column :current_sign_in_at
    actions :name => "Acções"
  end

  filter :nome
  filter :email
  filter :last_sign_in_at
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :nome
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
  
end

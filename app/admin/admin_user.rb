#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register AdminUser do

  menu :label => "Admin"
  permit_params :email, :password, :password_confirmation

  index :title => "Admin" do
    selectable_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions :name => "Acções"
  end

  filter :email
  filter :current_sign_in_at
  filter :created_at

  show do
    attributes_table :id, :email, :sign_in_count, :last_sign_in_at, :last_sign_in_ip, :created_at
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end

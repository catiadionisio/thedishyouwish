#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    section :class => "section-dashboard" do
        div :class => "titulo" do
            "Últimas receitas"
        end
        table_for Receita.order("created_at desc").limit(5) do
            column :nome do |receita|
                link_to receita.nome, [:admin, receita]
            end
            column "Tipo de refeição", :tiporefeicao do |receita|
              receita.tiporefeicaos.map(&:nome).join(", ").html_safe
            end
            column :dificuldade
            column :tempo do |receita|
              div :class => "tempo" do
                receita.tempo.to_s + " min"
              end
            end
        end

        div :class => "link-dashboard" do
            (link_to "Ver todas", admin_receitas_path) + " | " + (link_to "Adicionar nova", new_admin_receita_path)
        end
    end

    section :class => "section-dashboard" do
        div :class => "titulo" do
            "Últimos ingredientes"
        end
        table_for Ingrediente.order("created_at desc").limit(5) do
            column :nome do |ingrediente|
                link_to ingrediente.nome, [:admin, ingrediente]
            end
            column "Peso médio", :peso_medio
            column "Secção", :seccao
        end

        div :class => "link-dashboard" do
            (link_to "Ver todos", admin_ingredientes_path) + " | " + (link_to "Adicionar novo", new_admin_ingrediente_path)
        end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end

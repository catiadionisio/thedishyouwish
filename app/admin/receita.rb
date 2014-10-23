#!/bin/env ruby
# encoding: utf-8

ActiveAdmin.register Receita do

  controller do
    def permitted_params
      params.permit receita: [:nome, :tempo, :dificuldade, :descricao, :pessoas, :calorias, :hidratos, :acucar, :gorduras, :proteinas, :imagem, confeccaos_attributes: [:id, :passo, :ordem, :_update,:_create,:_destroy], categoria_ids: [], tiporefeicao_ids: [], ingrediente_ids: [], medida_ids: [], rating_ids: [], receita_ingredientes_attributes: [:id, :ingrediente_id, :quantidade, :nota, :medida_id, :_update,:_create,:_destroy] ]
    end

    def user_params
      params.require(:receita).permit(:imagem)
    end

    class Float
      def number_decimal_places
        self.to_s.length-2
      end
      
      def to_fraction
        if self.finite?
          number = (self*10.0).round / 10.0
        else
          number = self
        end

        higher = 10**number.number_decimal_places
        lower = number*higher

        gcden = greatest_common_divisor(higher, lower)

        numerator = (lower/gcden).round
        denominator = (higher/gcden).round

        if denominator == 1
          return numerator
        elsif numerator > denominator
          integer = numerator / denominator
          remainder = numerator % denominator
          return integer.to_s + " " + remainder.to_s  + "/" + denominator.to_s
        else 
          return numerator.to_s + "/" + denominator.to_s
        end
      end
      
    private

      def greatest_common_divisor(a, b)
         while a%b != 0
           a,b = b.round,(a%b).round
         end 
         return b
      end
    end

  end

  menu :label => "Receitas"

  index :title => "Receitas" do
    selectable_column
    column :nome
    column "Tipo de refeição", :tiporefeicao, :sortable => :tiporefeicao_id do |receita|
      receita.tiporefeicaos.map(&:nome).join(", ").html_safe
    end
    column :dificuldade
    column "Tempo (min)", :tempo, :sortable => :tempo
    column "Classificação" do |receita|
      if (receita.ratings.average(:classificacao).to_s).empty?
        "Sem classificação"
      else
        receita.ratings.average(:classificacao).to_s
      end
    end
    actions :name => "Acções"
  end

  show do
   attributes_table do
    row :id
    row :nome
    row 'Tipo de refeição' do
       receita.tiporefeicaos.map(&:nome).join(" | ").html_safe
    end
    row 'Categorias' do
       receita.categorias.map(&:nome).join(" | ").html_safe
    end
    row 'Tempo' do
       receita.tempo.to_s + " min"
    end
    row 'Dificuldade' do
       receita.dificuldade
    end
    row 'Nº de pessoas' do
       receita.pessoas
    end
    row 'Classificação' do |r|
      if (r.ratings.average(:classificacao).to_s).empty?
        "Sem classificação"
      else
        r.ratings.average(:classificacao).to_s
      end
    end
    row 'Descrição' do
       receita.descricao
    end
    row 'Imagem' do
       image_tag(receita.imagem.url(:preview))
    end
    row "Informação nutricional", :class => "no_number" do
      info = ["Calorias: " + receita.calorias.to_s + " Kcal", "Hidratos de carbono: " + receita.hidratos.to_s + "g", "Açúcar: " + receita.acucar.to_s + "g", "Gorduras: " + receita.gorduras.to_s + "g", "Proteínas: " + receita.proteinas.to_s + "g"]
      ol do
        info.each do |p|
            li do 
               p
            end
         end
      end
    end
    row 'Ingredientes', :class => "no_number" do
      ol do
        receita.receita_ingredientes.each do |p|
           if (p.medida.to_s == "Unidade")
             ing = p.quantidade.to_f.to_fraction.to_s + " " + p.ingrediente.to_s.downcase
           elsif (p.medida.to_s == "q.b.")
             ing = p.ingrediente.to_s.downcase + " " + p.medida.to_s.downcase
           elsif (p.medida.to_s == "Grama")
             ing = p.quantidade.to_i.to_s + "g " + p.ingrediente.to_s.downcase
           elsif (p.medida.to_s == "Mililitro")
             ing = p.quantidade.to_i.to_s + "ml " + p.ingrediente.to_s.downcase
           else
             ing = p.quantidade.to_f.to_fraction.to_s + " " + p.medida.to_s.downcase + " de " + p.ingrediente.to_s.downcase
           end

           if (p.nota.empty?)
            ing_nota = ing
           else
            ing_nota = ing + " (" + p.nota.to_s + ")"
           end

           li do 
               ing_nota
            end
         end
      end
    end
    row 'Confecção' do
      ol do
         receita.confeccaos.sort_by!{|m| m.ordem}.each do |p|
            li p.passo
         end
      end
    end
   end
  end


  filter :nome
  filter :receita_tiporefeicaos_tiporefeicao_id, as: :select, collection: Tiporefeicao.all, label: 'Tipo de refeição', :input_html => { :class => "chosen-select2" }
  filter :pessoas, label: 'Nº de pessoas'
  filter :receita_ingredientes_ingrediente_id, as: :select, collection: Ingrediente.all, label: 'Ingrediente', :input_html => { :class => "chosen-select2" }
  filter :receita_categorias_categoria_id, as: :select, collection: Categoria.all, label: 'Categoria', :input_html => { :class => "chosen-select2" }
  filter :tempo
  filter :dificuldade
  filter :ratings_classificacao, as: :numeric, collection: Rating.all, label: 'Classificação'
  filter :calorias
  filter :hidratos
  filter :acucar, label: 'Açúcar'
  filter :gorduras
  filter :proteinas, label: 'Proteínas'
  filter :created_at
  filter :updated_at


  form :html => { :enctype => "multipart/form-data" } do |f|
      f.inputs "Detalhes" do
        f.input :nome
        f.input :tiporefeicaos, :label => "Tipo de refeição", :as => :check_boxes
        f.input :categorias, :label => "Categoria", :as => :check_boxes
        f.input :tempo, :label => "Tempo (min)"
        f.input :pessoas, :label => "Nº de pessoas"
        f.input :dificuldade, :label => "Dificuldade"
        f.input :descricao, :label => "Descrição"
        f.input :imagem, :as => :file, :hint => f.template.image_tag(f.object.imagem.url(:thumb))
      end
      f.inputs "Ingredientes" do
        f.has_many :receita_ingredientes, :allow_destroy => true, :heading => 'Ingrediente:' do |c|
          c.input :ingrediente, :input_html => { :class => "chosen-select" }
          c.input :quantidade, :hint => "Insira apenas números, caso queira introduzir fracções, é necessário efectuar a conta primeiro e inserir apenas o resultado."
          c.input :nota
          c.input :medida, :input_html => { :class => "chosen-select" }
        end
      end
      f.inputs "Modo de confecção" do
        f.has_many :confeccaos, :allow_destroy => true, :heading => 'Passo' do |c|
          c.input :passo 
          c.input :ordem
        end
      end
      f.inputs "Informação nutricional" do
        f.input :calorias
        f.input :hidratos, :label => "Hidratos de carbono"
        f.input :acucar, :label => "Açúcar"
        f.input :gorduras
        f.input :proteinas, :label => "Proteínas"
      end

      f.actions
    end

  
end

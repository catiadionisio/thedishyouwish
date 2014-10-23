require "prawn/table"

date = @editarEmenta.data.to_date

foto = "#{Rails.root}/app/assets/images/logo3.png"
image foto, :width => 180, :position => :center

pdf.move_down(5)

pdf.text "#{("Ementa de " + date.to_s + " a " + (date.to_date+6).to_s).upcase}", :size => 10, :align => :center, :style => :bold, :color => "434343"

pdf.move_down(5)
stroke_horizontal_rule

pdf.move_down(25)

@letter_array = ["a","b","c", "d", "e", "f", "g"]

pdf.dash 2, :space => 5

existe = 0

@letter_array.each_with_index do |letter, indice|
    pdf.text "#{l(date+indice, format: :day_long)}", :size => 12, :align => :right, :style => :bold, :color => "434343"
    pdf.move_down(5)
    stroke_horizontal_rule
    pdf.move_down(20)

    receita_sum = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ?', "#{letter}1")

    if receita_sum.length > 0

        existe += 1

        pdf.text "Pequeno-Almoço", :size => 15, :align => :left, :style => :bold
        pdf.move_down(5)
        @i = 1
        while @i < 2  do
            receita_celula = EmentaReceita.where(:ementa_id => @editarEmenta.id, :celula => (letter+"1")).first

            if !receita_celula.blank?
              pdf.text "#{receita_celula.receita.nome} | #{receita_celula.npessoas} pessoas", :size => 10, :align => :left
              pdf.move_down(10)
            end

            @i +=1
        end
        pdf.move_down(15)
    end

    receita_sum = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ? OR celula LIKE ? OR celula LIKE ?', "#{letter}2", "#{letter}3", "#{letter}4")

    if receita_sum.length > 0

        existe += 1

        @i = 2
        pdf.text "Almoço", :size => 15, :align => :left, :style => :bold
        pdf.move_down(5)
        while @i < 5  do
            receita_celula = EmentaReceita.where(:ementa_id => @editarEmenta.id, :celula => (letter+@i.to_s)).first

            if !receita_celula.blank?
                if @i == 2
                  pdf.text "Entrada", :size => 10, :align => :left, :style => :bold
                elsif @i == 4
                  pdf.text "Sobremesa", :size => 10, :align => :left, :style => :bold
                else
                  pdf.text "Prato principal", :size => 10, :align => :left, :style => :bold
                end
                pdf.text "#{receita_celula.receita.nome} | #{receita_celula.npessoas} pessoas", :size => 10, :align => :left
                pdf.move_down(10)
            end
            @i +=1
        end

        pdf.move_down(15)
    end

    receita_sum = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ? OR celula LIKE ? OR celula LIKE ?', "#{letter}5", "#{letter}6", "#{letter}7")

    if receita_sum.length > 0

        existe += 1

        @i = 5
        pdf.text "Jantar", :size => 15, :align => :left, :style => :bold
        pdf.move_down(5)
        while @i < 8  do

          receita_celula = EmentaReceita.where(:ementa_id => @editarEmenta.id, :celula => (letter+@i.to_s)).first

            if !receita_celula.blank?
                if @i == 5
                  pdf.text "Entrada", :size => 10, :align => :left, :style => :bold
                elsif @i == 7
                  pdf.text "Sobremesa", :size => 10, :align => :left, :style => :bold
                else
                  pdf.text "Prato principal", :size => 10, :align => :left, :style => :bold
                end
                pdf.text "#{receita_celula.receita.nome} | #{receita_celula.npessoas} pessoas", :size => 10, :align => :left
                pdf.move_down(10)
            end
            @i +=1
        end

        pdf.move_down(20)
    end

    if existe == 0
      pdf.text "Não foram adicionadas receitas para este dia.", :size => 10, :align => :left
      pdf.move_down(20)
    end

    existe = 0
    @i = 1
end

start_new_page

image foto, :width => 180, :position => :center

pdf.move_down(5)

pdf.dash 2, :space => 0

pdf.text "#{("Receitas").upcase}", :size => 10, :align => :center, :style => :bold, :color => "434343"

pdf.move_down(5)
stroke_horizontal_rule
pdf.move_down(25)

pdf.dash 2, :space => 5

@i = 1

primeiro = 0
existe = 0

receitas_lista = []
receitas_imprimidas = []

@letter_array.each do |letter|
    while @i < 8  do
        receita_celula = EmentaReceita.where(:ementa_id => @editarEmenta.id, :celula => (letter+@i.to_s)).first

        if !receita_celula.blank?
          pessoas = receita_celula.npessoas
          receita_exists = receitas_lista.select {|x| x[:receita] == receita_celula.receita.id }

          if receita_exists.blank?
            hash = { :receita => receita_celula.receita.id, :npessoas => [pessoas] }
            receitas_lista.push(hash)
          else
            unless receita_exists[0][:npessoas].include?(pessoas)
              receita_exists[0][:npessoas].push(pessoas)
            end
          end

        end
        @i +=1
    end
    @i = 1
end


a = 0
a_size = receitas_lista.length

while a < a_size  do
    receita = Receita.find(receitas_lista[a][:receita])
    pessoas_num = receitas_lista[a][:npessoas]

    if primeiro != 0
      start_new_page
    end

    primeiro += 1
    existe += 1

    pdf.text "#{receita.nome}", :size => 12, :align => :right, :style => :bold, :color => "434343"
    pdf.move_down(5)
    stroke_horizontal_rule
    pdf.move_down(20)

    foto2 = "#{receita.imagem.path(:pdf)}"
    image foto2, :width => 630, :position => :center

    pdf.move_down(20)
    pdf.text "Ingredientes:", :size => 14, :style => :bold
    pdf.move_down(10)

    pessoas_num.each_with_index do |pessoas,index|

        pdf.text "Para #{pessoas} pessoas:", :size => 10, :align => :left, :style => :bold
        pdf.move_down(5)
        receita.receita_ingredientes.each do |p|
          if (p.medida.to_s == "Unidade")
            @print = "#{((p.quantidade.to_f*pessoas.to_i) / receita.pessoas).to_fraction} #{p.ingrediente.to_s.downcase}"

          elsif (p.medida.to_s == "q.b.")
            @print = "#{p.ingrediente.to_s.downcase} #{p.medida.to_s.downcase}"

          elsif (p.medida.to_s == "Grama")
            @print = "#{((p.quantidade.to_f*pessoas.to_i) / receita.pessoas).floor}g #{p.ingrediente.to_s.downcase}"

          elsif (p.medida.to_s == "Mililitro")
            @print = "#{((p.quantidade.to_f*pessoas.to_i) / receita.pessoas).floor}ml #{p.ingrediente.to_s.downcase}"

          else
            @print = "#{((p.quantidade.to_f*pessoas.to_i) / receita.pessoas).to_fraction} #{p.medida.to_s.downcase} de #{p.ingrediente.to_s.downcase}"
          end

          if (!p.nota.empty?)
            pdf.text "#{@print} (#{p.nota.to_s})", :size => 10

          else 
            pdf.text "#{@print}", :size => 10
          end
          pdf.move_down(5)
        end

        pdf.move_down(10)
    end

    pdf.move_down(15)

    pdf.text "Modo de confecção:", :size => 14, :style => :bold

    pdf.move_down(10)

    @li = 1

    receita.confeccaos.sort_by!{|m| m.ordem}.each do |p|
      pdf.text "#{@li}. #{p.passo}", :size => 10
      pdf.move_down(10)
      @li = @li + 1
    end

   a +=1
end



if existe == 0
  pdf.text "Não foram adicionadas receitas para esta ementa.", :size => 10, :align => :left
  pdf.move_down(20)
end

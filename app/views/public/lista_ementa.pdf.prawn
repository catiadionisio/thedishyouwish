require "prawn/table"

checkbox = "\u2610"
filled_checkbox = "\u2612"

font_families.update("DejaVuSans" => {
  :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
  :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
  :bold => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
  :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf"
})

font "DejaVuSans"

if !session["ementa_session"].blank?

  date = !session["data_ementa"].blank? ? session["data_ementa"].to_date : Date.today

  foto = "#{Rails.root}/app/assets/images/logo3.png"

  @letter_array = ["a","b","c", "d", "e", "f", "g"]

  image foto, :width => 180, :position => :center

  pdf.move_down(5)

  pdf.dash 2, :space => 0

  pdf.text "#{("Lista de compras | Ementa de " + date.to_s + " a " + (date.to_date+6).to_s).upcase}", :size => 10, :align => :center, :style => :bold, :color => "434343"

  pdf.move_down(5)
  stroke_horizontal_rule

  pdf.dash 2, :space => 5

  @i = 1

  ingredientes_lista = []

  @letter_array.each do |letter|
      while @i < 8  do
          if !session[letter+@i.to_s].blank?
            receita = Receita.find(session[letter+@i.to_s][:receita])
            pessoas = !session[letter+@i.to_s][:pessoas].blank? ? session[letter+@i.to_s][:pessoas] : "2"

            receita.receita_ingredientes.each do |p|
              ingrediente_exists = ingredientes_lista.select {|x| x[:ingrediente] == p.ingrediente.id }
              if ingrediente_exists.blank?
                hash = { :ingrediente => p.ingrediente.id, :ingrediente_nome => p.ingrediente.nome, :quantidade => (p.quantidade.to_f*pessoas.to_f), :seccao => p.ingrediente.seccao.nome, :medida_id => p.medida.id, :medida => p.medida.nome}
                ingredientes_lista.push(hash)
              else
                if ingrediente_exists[0][:medida] == p.medida.nome
                  ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f))
                else 
                  medida_ingrediente_antigo = Medida.find(ingrediente_exists[0][:medida_id])
                  medida_ingrediente_nova = p.medida.id

                  if medida_ingrediente_nova == 1 # colher de sopa
                    if medida_ingrediente_antigo.id == 2 # unidade
                      conversao = p.ingrediente.peso_medio / p.medida.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 2 + ((p.quantidade.to_f*pessoas.to_f))
                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      conversao = p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      conversao = p.medida.ml

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/3) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/6) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 8 # chavena

                      conversao = medida_ingrediente_antigo.gr/p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)
                    end

                  elsif medida_ingrediente_nova == 2 # unidade
                    if medida_ingrediente_antigo.id == 1 # colher de sopa
                      conversao = p.ingrediente.peso_medio / medida_ingrediente_antigo.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 1 + ((p.quantidade.to_f*pessoas.to_f))
                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      conversao = p.ingrediente.peso_medio

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      conversao = p.ingrediente.peso_medio

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha

                      conversao = p.ingrediente.peso_medio / medida_ingrediente_antigo.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe

                      conversao = p.ingrediente.peso_medio / medida_ingrediente_antigo.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 8 # chavena

                      conversao = p.ingrediente.peso_medio / medida_ingrediente_antigo.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome
                    end

                  elsif medida_ingrediente_nova == 3 # q.b.
                    if medida_ingrediente_antigo.id == 1 # colher de sopa
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 2

                    elsif medida_ingrediente_antigo.id == 2 # unidade
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 1

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 10

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 10

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 5

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 10

                    elsif medida_ingrediente_antigo.id == 8 # chavena
                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + 0.5                     
                    end

                  elsif medida_ingrediente_nova == 4 # grama
                    if medida_ingrediente_antigo.id == 1 # colher de sopa
                      conversao = medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 2 # unidade
                      conversao = p.ingrediente.peso_medio

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 10 + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      conversao = medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha
                      conversao = medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe
                      conversao = medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 8 # chavena
                      conversao = medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome                  
                    end

                  elsif medida_ingrediente_nova == 5 # mililitro
                    if medida_ingrediente_antigo.id == 1 # colher de sopa
                      conversao = medida_ingrediente_antigo.ml

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 2 # unidade
                      conversao = p.ingrediente.peso_medio

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 10 + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      conversao = medida_ingrediente_antigo.ml

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha
                      conversao = medida_ingrediente_antigo.ml

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe
                      conversao = medida_ingrediente_antigo.ml

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 8 # chavena
                      conversao = medida_ingrediente_antigo.ml

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]*conversao) + (p.quantidade.to_f*pessoas.to_f)

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome                  
                    end

                  elsif medida_ingrediente_nova == 6 # colher de cha
                    if medida_ingrediente_antigo.id == 1 # colher de sopa

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]) + ((p.quantidade.to_f*pessoas.to_f)/3)

                    elsif medida_ingrediente_antigo.id == 2 # unidade
                      conversao = p.ingrediente.peso_medio / p.medida.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 5 + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      conversao = p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      conversao = p.medida.ml

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe
                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/2) + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 8 # chavena

                      conversao = medida_ingrediente_antigo.gr/p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)                
                    end

                  elsif medida_ingrediente_nova == 7 # colher de cafe
                    if medida_ingrediente_antigo.id == 1 # colher de sopa
                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]) + ((p.quantidade.to_f*pessoas.to_f)/6)

                    elsif medida_ingrediente_antigo.id == 2 # unidade
                      conversao = p.ingrediente.peso_medio / p.medida.gr # colher -> unidade

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 10 + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      conversao = p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      conversao = p.medida.ml

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha
                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]) + ((p.quantidade.to_f*pessoas.to_f)/2)

                    elsif medida_ingrediente_antigo.id == 8 # chavena

                      conversao = medida_ingrediente_antigo.gr/p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)                
                    end

                  elsif medida_ingrediente_nova == 8 # chavena
                    if medida_ingrediente_antigo.id == 1 # colher de sopa
                      conversao = p.medida.gr/medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f)) 

                    elsif medida_ingrediente_antigo.id == 2 # unidade
                      conversao = p.ingrediente.peso_medio / p.medida.gr # chavena -> unidade

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)/conversao)

                    elsif medida_ingrediente_antigo.id == 3 # q.b.
                      ingrediente_exists[0][:quantidade] = 0.5 + ((p.quantidade.to_f*pessoas.to_f))

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome

                    elsif medida_ingrediente_antigo.id == 4 # grama
                      conversao = p.medida.gr

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 5 # mililitro
                      conversao = p.medida.ml

                      ingrediente_exists[0][:quantidade] = ingrediente_exists[0][:quantidade] + ((p.quantidade.to_f*pessoas.to_f)*conversao)

                    elsif medida_ingrediente_antigo.id == 6 # colher de cha
                      conversao = p.medida.gr/medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f))    

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome  

                    elsif medida_ingrediente_antigo.id == 7 # colher de cafe
                      conversao = p.medida.gr/medida_ingrediente_antigo.gr

                      ingrediente_exists[0][:quantidade] = (ingrediente_exists[0][:quantidade]/conversao) + ((p.quantidade.to_f*pessoas.to_f))    

                      ingrediente_exists[0][:medida_id] = p.medida.id
                      ingrediente_exists[0][:medida] = p.medida.nome              
                    end
                  end

                end
              end
            end
          end
          @i +=1
      end
      @i = 1
  end  

  ingredientes_lista_seccao = ingredientes_lista.group_by { |d| d[:seccao] }

  ingredientes_lista_seccao.each do |seccao, seccao_ingredientes|
    pdf.move_down(25)
    pdf.text "#{seccao}", :size => 12, :style => :bold, :color => "434343"
    pdf.move_down(5)
    stroke_horizontal_rule
    pdf.move_down(10)

    seccao_ingredientes.each do |p|
      if (p[:medida] == "Unidade")
        @print = "#{p[:quantidade].to_fraction} #{p[:ingrediente_nome]}"

      elsif (p[:medida] == "q.b.")
        @print = "#{p[:ingrediente_nome]} #{p[:medida]}"

      elsif (p[:medida] == "Grama")
        @print = "#{p[:quantidade].floor}g #{p[:ingrediente_nome]}"

      elsif (p[:medida] == "Mililitro")
        @print = "#{p[:quantidade].floor}ml #{p[:ingrediente_nome]}"

      else
        @print = "#{p[:quantidade].to_fraction} #{p[:medida]} de #{p[:ingrediente_nome]}"
      end

      pdf.text "#{checkbox} #{@print}", :size => 10
      pdf.move_down(5)
    end
  end

else
  foto = "#{Rails.root}/app/assets/images/logo3.png"
  image foto, :width => 180, :position => :center

  pdf.move_down(5)

  pdf.text "#{("Ementa").upcase}", :size => 10, :align => :center, :style => :bold, :color => "434343"

  pdf.move_down(5)
  stroke_horizontal_rule

  pdf.move_down(25)

  pdf.text "O documento que tentou aceder já não se encontra disponível", :size => 12, :align => :center, :style => :bold
end
foto = "#{Rails.root}/app/assets/images/logo3.png"
image foto, :width => 180, :position => :center

pdf.move_down(5)

pdf.text "#{("Receitas").upcase}", :size => 10, :align => :center, :style => :bold, :color => "434343"

pdf.move_down(5)
stroke_horizontal_rule
pdf.move_down(25)

pdf.dash 2, :space => 5

pdf.text "#{@verReceita.nome}", :size => 12, :align => :right, :style => :bold, :color => "434343"
pdf.move_down(5)
stroke_horizontal_rule
pdf.move_down(20)

foto2 = "#{@verReceita.imagem.path(:pdf)}"
image foto2, :width => 630, :position => :center

pdf.move_down(20)

session_id = !session["receita"+@verReceita[:id].to_s+"_pessoas"].blank? ? session["receita"+@verReceita[:id].to_s+"_pessoas"] : "2"

pdf.text "Ingredientes | #{session_id} pessoas:", :size => 14, :style => :bold

pdf.move_down(10)


@verReceita.receita_ingredientes.each do |p|
  if (p.medida.to_s == "Unidade")
    @print = "#{((p.quantidade.to_f*session_id.to_i) / @verReceita.pessoas).to_fraction} #{p.ingrediente.to_s.downcase}"

  elsif (p.medida.to_s == "q.b.")
    @print = "#{p.ingrediente.to_s.downcase} #{p.medida.to_s.downcase}"

  elsif (p.medida.to_s == "Grama")
    @print = "#{((p.quantidade.to_f*session_id.to_i) / @verReceita.pessoas).floor}g #{p.ingrediente.to_s.downcase}"

  elsif (p.medida.to_s == "Mililitro")
    @print = "#{((p.quantidade.to_f*session_id.to_i) / @verReceita.pessoas).floor}ml #{p.ingrediente.to_s.downcase}"

  else
    @print = "#{((p.quantidade.to_f*session_id.to_i) / @verReceita.pessoas).to_fraction} #{p.medida.to_s.downcase} de #{p.ingrediente.to_s.downcase}"
  end

  if (!p.nota.empty?)
    pdf.text "#{@print} (#{p.nota.to_s})", :size => 10

  else 
    pdf.text "#{@print}", :size => 10
  end
  pdf.move_down(5)
end

pdf.move_down(15)

pdf.text "Modo de confecção:", :size => 14, :style => :bold

pdf.move_down(10)

@li = 1

@verReceita.confeccaos.sort_by!{|m| m.ordem}.each do |p|
  pdf.text "#{@li}. #{p.passo}", :size => 10
  pdf.move_down(10)
  @li = @li + 1
end


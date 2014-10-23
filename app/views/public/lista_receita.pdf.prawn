checkbox = "\u2610"
filled_checkbox = "\u2612"

font_families.update("DejaVuSans" => {
  :normal => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
  :italic => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf",
  :bold => "#{Rails.root}/app/assets/fonts/DejaVuSans-Bold.ttf",
  :bold_italic => "#{Rails.root}/app/assets/fonts/DejaVuSans.ttf"
})

font "DejaVuSans"

foto = "#{Rails.root}/app/assets/images/logo3.png"
image foto, :width => 180, :position => :center

pdf.move_down(5)

pdf.text "Lista de compras | #{@verReceita.nome}", :size => 10, :align => :center, :style => :bold, :color => "434343"

pdf.move_down(5)
stroke_horizontal_rule

pdf.dash 2, :space => 5

session_id = !session["receita"+@verReceita[:id].to_s+"_pessoas"].blank? ? session["receita"+@verReceita[:id].to_s+"_pessoas"] : "2"

@verReceita_seccao = @verReceita.receita_ingredientes.group_by { |t| t.ingrediente.seccao }

@verReceita_seccao.each do |seccao, seccao_ingredientes|
  pdf.move_down(25)
  pdf.text "#{seccao}", :size => 12, :style => :bold, :color => "434343"
  pdf.move_down(5)
  stroke_horizontal_rule
  pdf.move_down(10)

  seccao_ingredientes.each do |p|
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
      pdf.text "#{checkbox} #{@print} (#{p.nota.to_s})", :size => 10

    else 
      pdf.text "#{checkbox} #{@print}", :size => 10
    end
    pdf.move_down(5)
  end
end
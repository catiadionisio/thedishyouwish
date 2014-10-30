class PublicController < ApplicationController
    def index
        @ultimas_receitas = Receita.order("id DESC").limit(4)
    end

    def receitas
        @receitas = Receita.search(params[:search]).order("id DESC").paginate(:page => params[:page], :per_page => 12)
        @categorias = Categoria.order("nome ASC")
        @ingredientes = Ingrediente.order("nome ASC")
    end

    def ajax_receitas
        if params["ingredientes_seleccionados"] != nil || params["categorias_seleccionadas"] != nil
            @receitas_ids = []
            
            if params["ingredientes_seleccionados"] != nil
                receitas_por_ingrediente_ids = []
                params["ingredientes_seleccionados"].split(",").each_with_index do |ingrediente_id, index|
                    temp = ReceitaIngrediente.where("ingrediente_id = ?", ingrediente_id).group("receita_id").map{ |obj| obj.receita_id }
                    # receitas_por_ingrediente_ids = (receitas_por_ingrediente_ids.length == 0) ? temp : (receitas_por_ingrediente_ids & temp)
                    
                    receitas_por_ingrediente_ids = (index == 0) ? temp : (receitas_por_ingrediente_ids & temp)
                end
                # => render :json => receitas_por_ingrediente_ids

                @receitas_ids = receitas_por_ingrediente_ids
            end

            if params["categorias_seleccionadas"] != nil
                receitas_por_categorias_ids = @receitas_ids = ReceitaCategoria.where("categoria_id IN (?)", params["categorias_seleccionadas"].split(",")).group("receita_id").map{ |obj| obj.receita_id }
            end

            #SE SELECIONARMOS INGREDIENTES E CATEGORIAS AO MESMO TEMPO SÓ DEVEM RESULTAR RECEITAS COMUNS A AMBOS OS FILTROS
            if params["ingredientes_seleccionados"] != nil && params["categorias_seleccionadas"] != nil
                @receitas_ids = receitas_por_ingrediente_ids & receitas_por_categorias_ids
            end

            @receitas = Receita.where("id IN (?)", @receitas_ids).search(params[:search]).order("id DESC").paginate(:page => params[:page], :per_page => 12)
        else
            @receitas = Receita.search(params[:search]).order("id DESC").paginate(:page => params[:page], :per_page => 12)
        end
        #render :json => @receitas_ids
        render :template => "layouts/_receitas", :layout => false
    end

    def receita
        @verReceita = Receita.find(params[:id])
        if session["receita"+params[:id]+"_pessoas"] == nil
            session["receita"+params[:id]+"_pessoas"] = "2"
        end
    end

    def lista_receita
        @verReceita = Receita.find(params[:id])
        if session["receita"+params[:id]+"_pessoas"] == nil
            session["receita"+params[:id]+"_pessoas"] = "2"
        end
    end

    def receita_pessoas
        id = params[:id]
        pessoas = params[:pessoas]

        if !session["receita"+id+"_pessoas"].blank?
            session["receita"+id+"_pessoas"] = pessoas
        end

        render :json => [id, pessoas]
    end

    def save_comment
        session[:return_to] ||= request.referer
        comentario = Comentario.new
        comentario.user_id = current_user.id if user_signed_in?
        if params[:nome].empty?
            comentario.nome = "Anónimo"
        else
            comentario.nome = params[:nome]
        end
        comentario.receita_id = params[:receitaid]
        comentario.conteudo = params[:conteudo]
        comentario.save

        redirect_to session.delete(:return_to)
    end

    def ajuda
    end

    def ementa
        @random_receita = Receita.first(:offset => rand(Receita.count))
        @receitas = Receita.order("nome ASC")

        if user_signed_in? 
            receitas_temp = UserReceita.where(:user_id => current_user.id).map{ |obj| obj.receita_id }
            @receitas_fav = Receita.order("nome ASC").find(receitas_temp)
        end

        if session["ementa_session"] == nil
            session["ementa_session"] = "activa"
        end

        if session["all"] == nil
            session["all"] = "2"
        end
    end

    def receitas_fav
        receita = params[:receita]
        celula = params[:celula]

        session[celula] = {receita: receita}

        if celula[1] == "1"
            if session["pa_pessoas"] != nil
                session[celula][:pessoas] = session["pa_pessoas"]
            end
        elsif celula[1] == "2" || celula[1] == "3" || celula[1] == "4"
            if session["a_pessoas"] != nil
                session[celula][:pessoas] = session["a_pessoas"]
            end
        elsif celula[1] == "5" || celula[1] == "6" || celula[1] == "7"
            if session["j_pessoas"] != nil
                session[celula][:pessoas] = session["j_pessoas"]
            end
        else
            if session["all"] != nil
                session[celula][:pessoas] = session["all"]
            end
        end

        redirect_to ementa_path
    end

    def receitas_all
        receita = params[:receita]
        celula = params[:celula]

        session[celula] = {receita: receita}

        if celula[1] == "1"
            if session["pa_pessoas"] != nil
                session[celula][:pessoas] = session["pa_pessoas"]
            end
        elsif celula[1] == "2" || celula[1] == "3" || celula[1] == "4"
            if session["a_pessoas"] != nil
                session[celula][:pessoas] = session["a_pessoas"]
            end
        elsif celula[1] == "5" || celula[1] == "6" || celula[1] == "7"
            if session["j_pessoas"] != nil
                session[celula][:pessoas] = session["j_pessoas"]
            end
        else
            if session["all"] != nil
                session[celula][:pessoas] = session["all"]
            end
        end

        redirect_to ementa_path
    end

    def lista_ementa
        @random_receita = Receita.first(:offset => rand(Receita.count))
        @receitas = Receita.order("id DESC")

        if session["ementa_session"] == nil
            session["ementa_session"] = "activa"
        end

        if session["all"] == nil
            session["all"] = "2"
        end
    end

    def gerar_ementa
        @dias = params[:dias] ? params[:dias] : nil
        @refeicoes = params[:refeicoes] ? params[:refeicoes] : nil
        @numeropessoas = params[:numeropessoas] ? params[:numeropessoas] : nil

        session["data_ementa"] = Date.commercial(Date.today.year, 1+Date.today.cweek, 1)

        if @numeropessoas != nil
            session["all"] = @numeropessoas.to_s
        end

        session["pa_pessoas"] = session["all"]
        session["a_pessoas"] = session["all"]
        session["j_pessoas"] = session["all"]

        @letter_array = ["a","b","c", "d", "e", "f", "g"]
        @i = 1

        if user_signed_in? 
            restricoes_ingredientes = Restricao.where(:user_id => current_user.id).map { |x| x.ingrediente_id }
            
            receita_array_temp = Receita.all.reject { |u| !(restricoes_ingredientes & u.receita_ingredientes.map { |x| x.ingrediente_id }).empty?}.map{ |obj| obj.id }

            receita_array = Receita.where("receita_id IN (?)", receita_array_temp)

        else
            receita_array = Receita.all
        end

        @letter_array.each do |letter|
            while @i < 8  do
                session[letter+@i.to_s] = nil
                if (@dias.include? letter)
                    if @i == 1
                        if (@refeicoes.include? 'palmoco')
                            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '4' })
                            if !@random_results.blank?
                                @random_receita = @random_results.first(:offset => rand(@random_results.count))

                                session[letter+@i.to_s] = {receita: @random_receita[:id]}
                                session[letter+@i.to_s][:pessoas] = session["pa_pessoas"]
                            else
                                session[:erro_restricoes] = 1
                            end 
                        end
                    end
                    if @i == 3
                        if (@refeicoes.include? 'almoco')
                            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                            if !@random_results.blank?
                                @random_receita = @random_results.first(:offset => rand(@random_results.count))

                                session[letter+@i.to_s] = {receita: @random_receita[:id]}
                                session[letter+@i.to_s][:pessoas] = session["a_pessoas"]
                            else
                                session[:erro_restricoes] = 1
                            end 
                        end
                    end
                    if @i == 6
                        if (@refeicoes.include? 'jantar')
                            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                            if !@random_results.blank?
                                @random_receita = @random_results.first(:offset => rand(@random_results.count))

                                session[letter+@i.to_s] = {receita: @random_receita[:id]}
                                session[letter+@i.to_s][:pessoas] = session["j_pessoas"]
                            else
                                session[:erro_restricoes] = 1
                            end 
                        end
                    end
                end
                @i +=1
            end
            @i = 1
        end

        redirect_to ementa_path
    end

    def ementa_diaria
        if session["data_ementa"] == nil
            session["data_ementa"] = Date.today
        end

        @dia_ementa = params[:dia_ementa] ? params[:dia_ementa] : "a"
    end

    def prev_day
        session[:return_to] ||= request.referer

        if session["data_ementa"] != nil
            session["data_ementa"] = session["data_ementa"].to_date - 1
        else
            session["data_ementa"] = Date.today - 1
        end

        redirect_to session.delete(:return_to)
    end

    def next_day
        session[:return_to] ||= request.referer

        if session["data_ementa"] != nil
            session["data_ementa"] = session["data_ementa"].to_date + 1
        else
            session["data_ementa"] = Date.today + 1
        end

        redirect_to session.delete(:return_to)
    end

    def add_ementa
        pessoas = session["all"]
        celula = params[:celula]
        receitaid = params[:receitaid].to_i

        if user_signed_in? 
            restricoes_ingredientes = Restricao.where(:user_id => current_user.id).map { |x| x.ingrediente_id }
            
            receita_array_temp = Receita.all.reject { |u| !(restricoes_ingredientes & u.receita_ingredientes.map { |x| x.ingrediente_id }).empty?}.map{ |obj| obj.id }

            receita_array = Receita.where("receita_id IN (?)", receita_array_temp)

        else
            receita_array = Receita.all
        end

        if celula[1] == "1"
            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '4' }).where.not(receita_tiporefeicaos: { receita_id: receitaid })
        elsif celula[1] == "2" || celula[1] == "5"
            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' }).where.not(receita_tiporefeicaos: { receita_id: receitaid })
        elsif celula[1] == "3" || celula[1] == "6"
            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' }).where.not(receita_tiporefeicaos: { receita_id: receitaid })
        else
            @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' }).where.not(receita_tiporefeicaos: { receita_id: receitaid })
        end

        if !@random_results.blank?
            @random_receita = @random_results.first(:offset => rand(@random_results.count))
            session[celula] = {receita: @random_receita[:id]}

            if celula[1] == "1"
                if session["pa_pessoas"] != nil
                    session[celula][:pessoas] = session["pa_pessoas"]
                    pessoas = session["pa_pessoas"]
                end
            elsif celula[1] == "2" || celula[1] == "3" || celula[1] == "4"
                if session["a_pessoas"] != nil
                    session[celula][:pessoas] = session["a_pessoas"]
                    pessoas = session["a_pessoas"]
                end
            elsif celula[1] == "5" || celula[1] == "6" || celula[1] == "7"
                if session["j_pessoas"] != nil
                    session[celula][:pessoas] = session["j_pessoas"]
                    pessoas = session["j_pessoas"]
                end
            end

            render :json => [celula, @random_receita[:nome], pessoas, @random_receita[:id]]
        else
            session[celula] = nil
            
            render :json => [celula, "sem_receita"]
        end 

        
    end

    def add_ementa_refeicao
        session[:return_to] ||= request.referer
        pessoas = session["all"]

        celula = params[:celula]
        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        if user_signed_in? 
            restricoes_ingredientes = Restricao.where(:user_id => current_user.id).map { |x| x.ingrediente_id }
            
            receita_array_temp = Receita.all.reject { |u| !(restricoes_ingredientes & u.receita_ingredientes.map { |x| x.ingrediente_id }).empty?}.map{ |obj| obj.id }

            receita_array = Receita.where("receita_id IN (?)", receita_array_temp)

        else
            receita_array = Receita.all
        end

        if celula == "pa"
            if session["pa_pessoas"] != nil
                pessoas = session["pa_pessoas"]
            end
            @letter_array.each do |letter|
                @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '4' })
                if !@random_results.blank?
                    @random_receita = @random_results.first(:offset => rand(@random_results.count))
                    if !session[letter+1.to_s].blank?
                        if session[letter+1.to_s][:lock] != "lock"
                            session[letter+1.to_s] = {receita: @random_receita[:id]}
                            session[letter+1.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+1.to_s] = {receita: @random_receita[:id]}
                        session[letter+1.to_s][:pessoas] = pessoas
                    end
                else
                    session[letter+1.to_s] = nil
                    session[:erro_restricoes] = 1
                end
            end
        elsif celula == "a"
            if session["a_pessoas"] != nil
                pessoas = session["a_pessoas"]
            end
            @letter_array.each do |letter|
                @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                if !@random_results.blank?
                    @random_receita = @random_results.first(:offset => rand(@random_results.count))
                    if !session[letter+3.to_s].blank?
                        if session[letter+3.to_s][:lock] != "lock"
                            session[letter+3.to_s] = {receita: @random_receita[:id]}
                            session[letter+3.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+3.to_s] = {receita: @random_receita[:id]}
                        session[letter+3.to_s][:pessoas] = pessoas
                    end
                else
                    session[letter+3.to_s] = nil
                    session[:erro_restricoes] = 1
                end
            end
            if session["entradaa"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+2.to_s].blank?
                            if session[letter+2.to_s][:lock] != "lock"
                                session[letter+2.to_s] = {receita: @random_receita[:id]}
                                session[letter+2.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+2.to_s] = {receita: @random_receita[:id]}
                            session[letter+2.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+2.to_s] = nil
                        session[:erro_restricoes] = 1
                    end
                end
            end
            
            if session["sobremesaa"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+4.to_s].blank?
                            if session[letter+4.to_s][:lock] != "lock"
                                session[letter+4.to_s] = {receita: @random_receita[:id]}
                                session[letter+4.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+4.to_s] = {receita: @random_receita[:id]}
                            session[letter+4.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+4.to_s] = nil
                        session[:erro_restricoes] = 1
                    end
                end
            end
        elsif celula == "j"
            if session["j_pessoas"] != nil
                pessoas = session["j_pessoas"]
            end
            @letter_array.each do |letter|
                @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                if !@random_results.blank?
                    @random_receita = @random_results.first(:offset => rand(@random_results.count))
                    if !session[letter+6.to_s].blank?
                        if session[letter+6.to_s][:lock] != "lock"
                            session[letter+6.to_s] = {receita: @random_receita[:id]}
                            session[letter+6.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+6.to_s] = {receita: @random_receita[:id]}
                        session[letter+6.to_s][:pessoas] = pessoas
                    end
                else
                    session[letter+6.to_s] = nil
                    session[:erro_restricoes] = 1
                end
            end

            if session["entradaj"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+5.to_s].blank?
                            if session[letter+5.to_s][:lock] != "lock"
                                session[letter+5.to_s] = {receita: @random_receita[:id]}
                                session[letter+5.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+5.to_s] = {receita: @random_receita[:id]}
                            session[letter+5.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+5.to_s] = nil
                        session[:erro_restricoes] = 1
                    end
                end
            end

            if session["sobremesaj"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+7.to_s].blank?
                            if session[letter+7.to_s][:lock] != "lock"
                                session[letter+7.to_s] = {receita: @random_receita[:id]}
                                session[letter+7.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+7.to_s] = {receita: @random_receita[:id]}
                            session[letter+7.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+7.to_s] = nil
                        session[:erro_restricoes] = 1
                    end
                end
            end
        end

        redirect_to session.delete(:return_to)
    end

    def nova_ementa
        session[:return_to] ||= request.referer
        pessoas = session["all"]

        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        @i = 1

        if user_signed_in? 
            restricoes_ingredientes = Restricao.where(:user_id => current_user.id).map { |x| x.ingrediente_id }
            
            receita_array_temp = Receita.all.reject { |u| !(restricoes_ingredientes & u.receita_ingredientes.map { |x| x.ingrediente_id }).empty?}.map{ |obj| obj.id }

            receita_array = Receita.where("receita_id IN (?)", receita_array_temp)

        else
            receita_array = Receita.all
        end

        until @i > 7  do
            if @i == 2
                if session["a_pessoas"] != nil
                    pessoas = session["a_pessoas"]
                end
                if session["entradaa"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+2.to_s].blank?
                                if session[letter+2.to_s][:lock] != "lock"
                                    session[letter+2.to_s] = {receita: @random_receita[:id]}
                                    session[letter+2.to_s][:pessoas] = pessoas
                                end
                            else
                                session[letter+2.to_s] = {receita: @random_receita[:id]}
                                session[letter+2.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+2.to_s] = nil
                            session[:erro_restricoes] = 1
                        end
                    end
                end
                pessoas = session["all"]
            elsif @i == 4
                if session["a_pessoas"] != nil
                    pessoas = session["a_pessoas"]
                end
                if session["sobremesaa"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })
                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+4.to_s].blank?
                                if session[letter+4.to_s][:lock] != "lock"
                                    session[letter+4.to_s] = {receita: @random_receita[:id]}
                                    session[letter+4.to_s][:pessoas] = pessoas
                                end
                            else
                                session[letter+4.to_s] = {receita: @random_receita[:id]}
                                session[letter+4.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+4.to_s] = nil
                            session[:erro_restricoes] = 1
                        end
                    end
                end
                pessoas = session["all"]
            elsif @i == 5
                if session["j_pessoas"] != nil
                    pessoas = session["j_pessoas"]
                end
                if session["entradaj"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+5.to_s].blank?
                                if session[letter+5.to_s][:lock] != "lock"
                                    session[letter+5.to_s] = {receita: @random_receita[:id]}
                                    session[letter+5.to_s][:pessoas] = pessoas
                                end
                            else
                                session[letter+5.to_s] = {receita: @random_receita[:id]}
                                session[letter+5.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+5.to_s] = nil
                            session[:erro_restricoes] = 1
                        end
                    end
                end
                pessoas = session["all"]
            elsif @i == 7
                if session["j_pessoas"] != nil
                    pessoas = session["j_pessoas"]
                end
                if session["sobremesaj"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })

                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+7.to_s].blank?
                                if session[letter+7.to_s][:lock] != "lock"
                                    session[letter+7.to_s] = {receita: @random_receita[:id]}
                                    session[letter+7.to_s][:pessoas] = pessoas
                                end
                            else
                                session[letter+7.to_s] = {receita: @random_receita[:id]}
                                session[letter+7.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+7.to_s] = nil
                            session[:erro_restricoes] = 1
                        end
                    end
                end
                pessoas = session["all"]
            else
                if @i == 1
                    if session["pa_pessoas"] != nil
                        pessoas = session["pa_pessoas"]
                    end
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '4' })
                elsif @i == 3
                    if session["a_pessoas"] != nil
                        pessoas = session["a_pessoas"]
                    end
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                elsif @i == 6
                    if session["j_pessoas"] != nil
                        pessoas = session["j_pessoas"]
                    end
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                end
                @letter_array.each do |letter|
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+@i.to_s].blank?
                            if session[letter+@i.to_s][:lock] != "lock"
                                session[letter+@i.to_s] = {receita: @random_receita[:id]}
                                session[letter+@i.to_s][:pessoas] = pessoas
                            end
                        else
                            session[letter+@i.to_s] = {receita: @random_receita[:id]}
                            session[letter+@i.to_s][:pessoas] = pessoas
                        end
                    else
                        session[letter+@i.to_s] = nil
                        session[:erro_restricoes] = 1
                    end
                end
            end
            @i +=1;
            pessoas = session["all"]
        end

        redirect_to session.delete(:return_to)
    end

    def reset
        session[:return_to] ||= request.referer

        @letter_array = ["a","b","c", "d", "e", "f", "g"]
        @i = 1

        @letter_array.each do |letter|
            while @i < 8  do
                if !session[letter+@i.to_s].blank?
                    if session[letter+@i.to_s][:lock] != "lock"
                        session[letter+@i.to_s] = nil
                    end
                else
                    session[letter+@i.to_s] = nil
                end
                @i +=1
            end
            @i = 1
        end

        session["pa_pessoas"] = session["all"]
        session["a_pessoas"] = session["all"]
        session["j_pessoas"] = session["all"]

        redirect_to session.delete(:return_to)
    end

    def ementa_delete
        celula = params[:celula]
        session[celula] = nil

        render :json => [celula]
    end

    def ementa_delete_refeicao
        session[:return_to] ||= request.referer
        @letter_array = ["a","b","c", "d", "e", "f", "g"]
        celula = params[:celula]

        if celula == "pa"
            @letter_array.each do |letter|
                if !session[letter+1.to_s].blank?
                    if session[letter+1.to_s][:lock] != "lock"
                        session[letter+1.to_s] = nil
                    end
                else
                    session[letter+1.to_s] = nil
                end
            end
        elsif celula == "a"
            @i = 2

            @letter_array.each do |letter|
                while @i < 5  do                   
                    if !session[letter+@i.to_s].blank?
                        if session[letter+@i.to_s][:lock] != "lock"
                            session[letter+@i.to_s] = nil
                        end
                    else
                        session[letter+@i.to_s] = nil
                    end
                    @i +=1
                end
                @i = 2
            end
        elsif celula == "j"
            @i = 5

            @letter_array.each do |letter|
                while @i < 8  do
                    if !session[letter+@i.to_s].blank?
                        if session[letter+@i.to_s][:lock] != "lock"
                            session[letter+@i.to_s] = nil
                        end
                    else
                        session[letter+@i.to_s] = nil
                    end
                    @i +=1
                end
                @i = 5
            end  
        end

        redirect_to session.delete(:return_to)
    end

    def ementa_extras
        refeicao = params[:refeicao]
        estado = params[:estado]
        session[refeicao] = estado
        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        if estado != "activo"
            if refeicao == "entradaa"
                @letter_array.each do |letter|
                    session[letter+2.to_s] = nil
                end
                linha = 2
            elsif refeicao == "sobremesaa"
                @letter_array.each do |letter|
                    session[letter+4.to_s] = nil
                end
                linha = 4
            elsif refeicao == "entradaj"
                @letter_array.each do |letter|
                    session[letter+5.to_s] = nil
                end
                linha = 5
            elsif refeicao == "sobremesaj"
                @letter_array.each do |letter|
                    session[letter+7.to_s] = nil
                end
                linha = 7
            end
        else
            linha = 0
        end

        render :json => [linha]
    end

    def ementa_lock
        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        if params[:celula] == "pa_lock"
            session[params[:celula]] = params[:estado]
            @letter_array.each do |letter|
                if !session[letter+1.to_s].blank?
                    session[letter+1.to_s][:lock] = params[:estado]
                end
            end
        elsif params[:celula] == "a_lock"
            session[params[:celula]] = params[:estado]
            @i = 2

            @letter_array.each do |letter|
                while @i < 5  do                   
                    if !session[letter+@i.to_s].blank?
                        session[letter+@i.to_s][:lock] = params[:estado]
                    end
                    @i +=1
                end
                @i = 2
            end
        elsif params[:celula] == "j_lock"
            session[params[:celula]] = params[:estado]
            @i = 5

            @letter_array.each do |letter|
                while @i < 8  do                   
                    if !session[letter+@i.to_s].blank?
                        session[letter+@i.to_s][:lock] = params[:estado]
                    end
                    @i +=1
                end
                @i = 5
            end
        else
            session[params[:celula]][:lock] = params[:estado]
        end

        render :json => [params[:celula], params[:estado]]
    end

    def ementa_pessoas
        celula = params[:celula]
        pessoas = params[:pessoas]

        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        if celula == "pa_pessoas"
            session[celula] = pessoas
            @letter_array.each do |letter|
                if !session[letter+1.to_s].blank?
                    session[letter+1.to_s][:pessoas] = pessoas
                end
            end
        elsif celula == "a_pessoas"
            session[celula] = pessoas
            @i = 2

            @letter_array.each do |letter|
                while @i < 5  do                   
                    if !session[letter+@i.to_s].blank?
                        session[letter+@i.to_s][:pessoas] = pessoas
                    end
                    @i +=1
                end
                @i = 2
            end
        elsif celula == "j_pessoas"
            session[celula] = pessoas
            @i = 5

            @letter_array.each do |letter|
                while @i < 8  do                   
                    if !session[letter+@i.to_s].blank?
                        session[letter+@i.to_s][:pessoas] = pessoas
                    end
                    @i +=1
                end
                @i = 5
            end  
        elsif celula == "all"
            session[celula] = pessoas
            @i = 1

            @letter_array.each do |letter|
                while @i < 8  do                   
                    if !session[letter+@i.to_s].blank?
                        session[letter+@i.to_s][:pessoas] = pessoas
                    end
                    @i +=1
                end
                @i = 1
            end
            session["pa_pessoas"] = pessoas
            session["a_pessoas"] = pessoas
            session["j_pessoas"] = pessoas
        else
            session[celula][:pessoas] = pessoas
        end

        render :json => [celula, pessoas]
    end

    def guardar_ementa
        session[:return_to] ||= request.referer

        if user_signed_in? 

            if (!session["ementa"].blank? && params[:ne] == "0")
                ementa = Ementa.where(:id => session["ementa"].to_i).first
                ementa.user_id = current_user.id
                ementa.data = params[:day]
                ementa.npessoas = (session["all"] == "0") ? 2 : session["all"]

                ementa.save

                actividade = Actividade.new(:user_id => current_user.id, :accao => "update", :tipo => "ementa", :tipoid => ementa.id, :created_at =>  DateTime.now.beginning_of_day.. DateTime.now.end_of_day)
                actividade.save
            else
                ementa = Ementa.new(:user_id => current_user.id, :data => params[:day], :npessoas => session["all"])
                ementa.save
                session["ementa"] = ementa.id

                actividade = Actividade.new(:user_id => current_user.id, :accao => "add", :tipo => "ementa", :tipoid => ementa.id, :created_at =>  DateTime.now.beginning_of_day.. DateTime.now.end_of_day)
                actividade.save
            end

            @letter_array = ["a","b","c", "d", "e", "f", "g"]
            @i = 1

            @letter_array.each do |letter|
                while @i < 8  do                   
                    if !session[letter+@i.to_s].blank?
                        
                        @pessoas_celula = (session[letter+@i.to_s][:pessoas].to_i == 0) ? 2 : session[letter+@i.to_s][:pessoas].to_i

                        if celula = EmentaReceita.where(:ementa_id => ementa.id, :celula => letter+@i.to_s).first
                            celula.ementa_id = ementa.id
                            celula.celula = letter+@i.to_s
                            celula.receita_id = session[letter+@i.to_s][:receita].to_i
                            celula.npessoas = @pessoas_celula
                            celula.save
                        else
                            celula = EmentaReceita.new(:ementa_id => ementa.id, :receita_id => session[letter+@i.to_s][:receita].to_i, :npessoas => @pessoas_celula, :celula => letter+@i.to_s)
                            celula.save
                        end
                    else
                        if celula = EmentaReceita.where(:ementa_id => ementa.id, :celula => letter+@i.to_s).first
                            celula.destroy
                        end
                    end
                    @i +=1
                end
                @i = 1
            end
        end

        #render :json => [params[:day], ementa.id]
        redirect_to session[:return_to]
    end

end

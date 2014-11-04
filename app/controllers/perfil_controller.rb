class PerfilController < ApplicationController
    before_action :authenticate_user!
    
    def perfil
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at")
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")

        @actividades_dia = Actividade.where(:user_id => current_user.id).where("created_at BETWEEN ? AND ?", DateTime.now.beginning_of_month, DateTime.now)
        @actividades_mes = Actividade.where(:user_id => current_user.id).where("created_at BETWEEN ? AND ?", DateTime.now.beginning_of_year, DateTime.now.beginning_of_month)
        @actividades_ano = Actividade.where(:user_id => current_user.id).where("created_at <= ?", DateTime.now.beginning_of_year)
        @actividade_grupo_dias = @actividades_dia.group_by { |t| t.created_at.beginning_of_day }
        @actividade_grupo_mes = @actividades_mes.group_by { |t| t.created_at.beginning_of_month }
        @actividade_grupo_ano = @actividades_ano.group_by { |t| t.created_at.beginning_of_year }
    end
    
    def perfil_mes
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at")
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")

        @mes = params[:mes] ? Date.parse(params[:mes]) : Date.today
        @actividades_mes = Actividade.where(:user_id => current_user.id).where("created_at BETWEEN ? AND ?", @mes.beginning_of_month, @mes.end_of_month)
        @actividade_grupo_dias = @actividades_mes.group_by { |t| t.created_at.beginning_of_day }
    end
    
    def perfil_ano
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at")
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")

        @ano = params[:ano] ? Date.parse(params[:ano]) : Date.today
        @actividades_ano = Actividade.where(:user_id => current_user.id).where("created_at BETWEEN ? AND ?", @ano.beginning_of_year, @ano.end_of_year)
        @actividade_grupo_mes = @actividades_ano.group_by { |t| t.created_at.beginning_of_month }
    end

    def receitas
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at DESC")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at DESC")
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")
    end

    def ementas
        if params["id"] != nil
            @ementas_id = Ementa.where("id IN (?)", params["id"].split(","))

            @array_params = params["id"].split(",")
            @ementas_apagadas = 0
            @array_actividade = []

            @array_params.each do |a|
                if actividade = Actividade.where(:user_id => current_user.id, :tipoid => a.to_i, :tipo => "ementa", :accao => "remove").first
                    @array_actividade.push(actividade.id)
                    @ementas_apagadas += 1
                end
            end
        end

        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at DESC")
        @ementas = params[:id] ? @ementas_id : Ementa.where(:user_id => current_user.id).order("data DESC, created_at DESC")
        @ementas_guardadas = Ementa.where(:user_id => current_user.id).order("created_at DESC").length
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")
    end

    def ementa_perfil
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at DESC")
        @ementas = Ementa.where(:user_id => current_user.id).order("data DESC, created_at DESC")
        @editarEmenta = Ementa.find(params[:id])
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")

        @receitas_all = Receita.order("nome ASC")

        if user_signed_in? 
            receitas_temp = UserReceita.where(:user_id => current_user.id).map{ |obj| obj.receita_id }
            @receitas_fav = Receita.order("nome ASC").find(receitas_temp)
        end

        if session["all_ee"] == nil
            session["all_ee"] = "2"
        end

        if session["entradaa_ee"] != "inactivo"
            receita_extra = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ?', "%2")
            if receita_extra.length > 0
                session["entradaa_ee"] = "activo"
            end
        end

        if session["sobremesaa_ee"] != "inactivo"
            receita_extra = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ?', "%4")
            if receita_extra.length > 0
                session["sobremesaa_ee"] = "activo"
            end
        end

        if session["entradaj_ee"] != "inactivo"
            receita_extra = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ?', "%5")
            if receita_extra.length > 0
                session["entradaj_ee"] = "activo"
            end
        end

        if session["sobremesaj_ee"] != "inactivo"
            receita_extra = EmentaReceita.where(:ementa_id => @editarEmenta.id).where('celula LIKE ?', "%7")
            if receita_extra.length > 0
                session["sobremesaj_ee"] = "activo"
            end
        end
    end

    def receitas_actividade
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at DESC")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at DESC")
        @receitas_guardadas = Receita.where("id IN (?)", params["id"].split(","))
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")
    end

    def apagar_ementa
        ementa = Ementa.find(params[:id])

        if (!session["ementa_ee"].blank?)
            if ementa.id == session["ementa_ee"].to_i
                session["ementa_ee"] = nil
            end
        end

        actividade = Actividade.new(:user_id => current_user.id, :accao => "remove", :tipo => "ementa", :tipoid => ementa.id, :created_at =>  DateTime.now.beginning_of_day.. DateTime.now.end_of_day)
        actividade.save

        EmentaReceita.where(:ementa_id => ementa.id).destroy_all
        ementa.destroy

        redirect_to perfil_path
    end

    def restricoes
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at")
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")

        restricoes_ingredientes = Restricao.where(:user_id => current_user.id).map { |x| x.ingrediente_id }

        @ingredientes = Ingrediente.all.order("nome ASC").reject { |u| restricoes_ingredientes.include?(u.id) }
    end

    def add_restricao
        if !params[:ingrediente].empty? 
            restricao = Restricao.new
            restricao.user_id = current_user.id
            restricao.ingrediente_id = params[:ingrediente]
            restricao.save
        end

        redirect_to restricoes_path
    end

    def remover_restricao
        restricao = Restricao.where(:id => params[:id]).first
        restricao.destroy

        redirect_to restricoes_path
    end

    #EDITAR EMENTA

    def ee_receitas_fav
        session[:return_to] ||= request.referer

        receita = params[:receita]
        celula = params[:celula]+"_ee"

        session[celula] = {receita: receita}

        if celula[1] == "1"
            if session["pa_pessoas_ee"] != nil
                session[celula][:pessoas] = session["pa_pessoas_ee"]
            end
        elsif celula[1] == "2" || celula[1] == "3" || celula[1] == "4"
            if session["a_pessoas_ee"] != nil
                session[celula][:pessoas] = session["a_pessoas_ee"]
            end
        elsif celula[1] == "5" || celula[1] == "6" || celula[1] == "7"
            if session["j_pessoas_ee"] != nil
                session[celula][:pessoas] = session["j_pessoas_ee"]
            end
        else
            if session["all_ee"] != nil
                session[celula][:pessoas] = session["all_ee"]
            else
                session[celula][:pessoas] = "2"
            end
        end

        redirect_to session.delete(:return_to)
    end

    def ee_receitas_all
        session[:return_to] ||= request.referer

        receita = params[:receita]
        celula = params[:celula]+"_ee"

        session[celula] = {receita: receita}

        if celula[1] == "1"
            if session["pa_pessoas_ee"] != nil
                session[celula][:pessoas] = session["pa_pessoas_ee"]
            end
        elsif celula[1] == "2" || celula[1] == "3" || celula[1] == "4"
            if session["a_pessoas_ee"] != nil
                session[celula][:pessoas] = session["a_pessoas_ee"]
            end
        elsif celula[1] == "5" || celula[1] == "6" || celula[1] == "7"
            if session["j_pessoas_ee"] != nil
                session[celula][:pessoas] = session["j_pessoas_ee"]
            end
        else
            if session["all_ee"] != nil
                session[celula][:pessoas] = session["all_ee"]
            else
                session[celula][:pessoas] = "2"
            end
        end

        redirect_to session.delete(:return_to)
    end

    #FALTA FAZER

    def ee_ementa_diaria
        if session["data_ementa_ee"] == nil
            session["data_ementa_ee"] = Date.today
        end

        @dia_ementa = params[:dia_ementa] ? params[:dia_ementa] : "a"
    end

    def ee_prev_day
        session[:return_to] ||= request.referer

        if session["data_ementa_ee"] != nil
            session["data_ementa_ee"] = session["data_ementa_ee"].to_date - 1
        else
            session["data_ementa_ee"] = Date.today - 1
        end

        redirect_to session.delete(:return_to)
    end

    def ee_next_day
        session[:return_to] ||= request.referer

        if session["data_ementa_ee"] != nil
            session["data_ementa_ee"] = session["data_ementa_ee"].to_date + 1
        else
            session["data_ementa_ee"] = Date.today + 1
        end

        redirect_to session.delete(:return_to)
    end

    def ee_add_ementa
        pessoas = session["all_ee"]
        celula = params[:celula]+"_ee"
        receitaid = params[:receitaid].to_i

        session[celula + "_empty"] = nil

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
                if session["pa_pessoas_ee"] != nil
                    session[celula][:pessoas] = session["pa_pessoas_ee"]
                    pessoas = session["pa_pessoas_ee"]
                else
                    session[celula][:pessoas] = session["all_ee"]
                    pessoas = session["all_ee"]
                end
            elsif celula[1] == "2" || celula[1] == "3" || celula[1] == "4"
                if session["a_pessoas"] != nil
                    session[celula][:pessoas] = session["a_pessoas_ee"]
                    pessoas = session["a_pessoas_ee"]
                else
                    session[celula][:pessoas] = session["all_ee"]
                    pessoas = session["all_ee"]
                end
            elsif celula[1] == "5" || celula[1] == "6" || celula[1] == "7"
                if session["j_pessoas"] != nil
                    session[celula][:pessoas] = session["j_pessoas_ee"]
                    pessoas = session["j_pessoas_ee"]
                else
                    session[celula][:pessoas] = session["all_ee"]
                    pessoas = session["all_ee"]
                end
            end

            render :json => [params[:celula], @random_receita[:nome], pessoas, @random_receita[:id]]
        else
            session[celula] = nil
            
            render :json => [params[:celula], "sem_receita"]
        end 

        
    end

    def ee_add_ementa_refeicao
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
            if session["pa_pessoas_ee"] != nil
                pessoas = session["pa_pessoas_ee"]
            end
            @letter_array.each do |letter|
                @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '4' })
                if !@random_results.blank?
                    @random_receita = @random_results.first(:offset => rand(@random_results.count))
                    if !session[letter+"1_ee"].blank?
                        if session[letter+"1_ee"][:lock] != "lock"
                            session[letter+"1_ee"] = {receita: @random_receita[:id]}
                            session[letter+"1_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"1_ee"] = {receita: @random_receita[:id]}
                        session[letter+"1_ee"][:pessoas] = pessoas
                    end
                else
                    session[letter+"1_ee"] = nil
                    session[:erro_restricoes] = 1
                end
                session[letter+"1_ee_empty"] = nil
            end
        elsif celula == "a"
            if session["a_pessoas_ee"] != nil
                pessoas = session["a_pessoas_ee"]
            end
            @letter_array.each do |letter|
                @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                if !@random_results.blank?
                    @random_receita = @random_results.first(:offset => rand(@random_results.count))
                    if !session[letter+"3_ee"].blank?
                        if session[letter+"3_ee"][:lock] != "lock"
                            session[letter+"3_ee"] = {receita: @random_receita[:id]}
                            session[letter+"3_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"3_ee"] = {receita: @random_receita[:id]}
                        session[letter+"3_ee"][:pessoas] = pessoas
                    end
                else
                    session[letter+"3_ee".to_] = nil
                    session[:erro_restricoes] = 1
                end
                session[letter+"3_ee_empty"] = nil
            end
            if session["entradaa_ee"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+"2_ee"].blank?
                            if session[letter+"2_ee"][:lock] != "lock"
                                session[letter+"2_ee"] = {receita: @random_receita[:id]}
                                session[letter+"2_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"2_ee"] = {receita: @random_receita[:id]}
                            session[letter+"2_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"2_ee"] = nil
                        session[:erro_restricoes] = 1
                    end
                    session[letter+"2_ee_empty"] = nil
                end
            end
            
            if session["sobremesaa_ee"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+"4_ee"].blank?
                            if session[letter+"4_ee"][:lock] != "lock"
                                session[letter+"4_ee"] = {receita: @random_receita[:id]}
                                session[letter+"4_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"4_ee"] = {receita: @random_receita[:id]}
                            session[letter+"4_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"4_ee"] = nil
                        session[:erro_restricoes] = 1
                    end
                    session[letter+"4_ee_empty"] = nil
                end
            end
        elsif celula == "j"
            if session["j_pessoas_ee"] != nil
                pessoas = session["j_pessoas_ee"]
            end
            @letter_array.each do |letter|
                @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                if !@random_results.blank?
                    @random_receita = @random_results.first(:offset => rand(@random_results.count))
                    if !session[letter+"6_ee"].blank?
                        if session[letter+"6_ee"][:lock] != "lock"
                            session[letter+"6_ee"] = {receita: @random_receita[:id]}
                            session[letter+"6_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"6_ee"] = {receita: @random_receita[:id]}
                        session[letter+"6_ee"][:pessoas] = pessoas
                    end
                else
                    session[letter+"6_ee"] = nil
                    session[:erro_restricoes] = 1
                end
                session[letter+"6_ee_empty"] = nil
            end

            if session["entradaj_ee"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+"5_ee"].blank?
                            if session[letter+"5_ee"][:lock] != "lock"
                                session[letter+"5_ee"] = {receita: @random_receita[:id]}
                                session[letter+"5_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"5_ee"] = {receita: @random_receita[:id]}
                            session[letter+"5_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"5_ee"] = nil
                        session[:erro_restricoes] = 1
                    end
                    session[letter+"5_ee_empty"] = nil
                end
            end

            if session["sobremesaj_ee"] == "activo"
                @letter_array.each do |letter|
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+"7_ee"].blank?
                            if session[letter+"7_ee"][:lock] != "lock"
                                session[letter+"7_ee"] = {receita: @random_receita[:id]}
                                session[letter+"7_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"7_ee"] = {receita: @random_receita[:id]}
                            session[letter+"7_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+"7_ee"] = nil
                        session[:erro_restricoes] = 1
                    end
                    session[letter+"7_ee_empty"] = nil
                end
            end
        end

        redirect_to session.delete(:return_to)
    end

    def ee_nova_ementa
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
                if session["a_pessoas_ee"] != nil
                    pessoas = session["a_pessoas_ee"]
                end
                if session["entradaa_ee"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+"2_ee"].blank?
                                if session[letter+"2_ee"][:lock] != "lock"
                                    session[letter+"2_ee"] = {receita: @random_receita[:id]}
                                    session[letter+"2_ee"][:pessoas] = pessoas
                                end
                            else
                                session[letter+"2_ee"] = {receita: @random_receita[:id]}
                                session[letter+"2_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"2_ee"] = nil
                            session[:erro_restricoes] = 1
                        end
                        session[letter+"2_ee_empty"] = nil
                    end
                end
                pessoas = session["all"]
            elsif @i == 4
                if session["a_pessoas_ee"] != nil
                    pessoas = session["a_pessoas_ee"]
                end
                if session["sobremesaa_ee"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })
                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+"4_ee"].blank?
                                if session[letter+"4_ee"][:lock] != "lock"
                                    session[letter+"4_ee"] = {receita: @random_receita[:id]}
                                    session[letter+"4_ee"][:pessoas] = pessoas
                                end
                            else
                                session[letter+"4_ee"] = {receita: @random_receita[:id]}
                                session[letter+"4_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"4_ee"] = nil
                            session[:erro_restricoes] = 1
                        end
                        session[letter+"4_ee_empty"] = nil
                    end
                end
                pessoas = session["all"]
            elsif @i == 5
                if session["j_pessoas_ee"] != nil
                    pessoas = session["j_pessoas_ee"]
                end
                if session["entradaj_ee"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '1' })
                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+"5_ee"].blank?
                                if session[letter+"5_ee"][:lock] != "lock"
                                    session[letter+"5_ee"] = {receita: @random_receita[:id]}
                                    session[letter+"5_ee"][:pessoas] = pessoas
                                end
                            else
                                session[letter+"5_ee"] = {receita: @random_receita[:id]}
                                session[letter+"5_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"5_ee"] = nil
                            session[:erro_restricoes] = 1
                        end
                        session[letter+"5_ee_empty"] = nil
                    end
                end
                pessoas = session["all"]
            elsif @i == 7
                if session["j_pessoas_ee"] != nil
                    pessoas = session["j_pessoas_ee"]
                end
                if session["sobremesaj_ee"] == "activo"
                    @letter_array.each do |letter|
                        @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '2' })

                        if !@random_results.blank?
                            @random_receita = @random_results.first(:offset => rand(@random_results.count))
                            if !session[letter+"7_ee"].blank?
                                if session[letter+"7_ee"][:lock] != "lock"
                                    session[letter+"7_ee"] = {receita: @random_receita[:id]}
                                    session[letter+"7_ee"][:pessoas] = pessoas
                                end
                            else
                                session[letter+"7_ee"] = {receita: @random_receita[:id]}
                                session[letter+"7_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+"7_ee"] = nil
                            session[:erro_restricoes] = 1
                        end
                        session[letter+"7_ee_empty"] = nil
                    end
                end
                pessoas = session["all"]
            else
                if @i == 1
                    if session["pa_pessoas_ee"] != nil
                        pessoas = session["pa_pessoas_ee"]
                    end
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '4' })
                elsif @i == 3
                    if session["a_pessoas_ee"] != nil
                        pessoas = session["a_pessoas_ee"]
                    end
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                elsif @i == 6
                    if session["j_pessoas_ee"] != nil
                        pessoas = session["j_pessoas_ee"]
                    end
                    @random_results = receita_array.includes(:receita_tiporefeicaos).where(receita_tiporefeicaos: { tiporefeicao_id: '3' })
                end
                @letter_array.each do |letter|
                    if !@random_results.blank?
                        @random_receita = @random_results.first(:offset => rand(@random_results.count))
                        if !session[letter+@i.to_s+"_ee"].blank?
                            if session[letter+@i.to_s+"_ee"][:lock] != "lock"
                                session[letter+@i.to_s+"_ee"] = {receita: @random_receita[:id]}
                                session[letter+@i.to_s+"_ee"][:pessoas] = pessoas
                            end
                        else
                            session[letter+@i.to_s+"_ee"] = {receita: @random_receita[:id]}
                            session[letter+@i.to_s+"_ee"][:pessoas] = pessoas
                        end
                    else
                        session[letter+@i.to_s+"_ee"] = nil
                        session[:erro_restricoes] = 1
                    end
                    session[letter+@i.to_s+"_ee_empty"] = nil
                end
            end
            @i +=1;
            pessoas = session["all_ee"]
        end

        redirect_to session.delete(:return_to)
    end

    def ee_reset
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

    def ee_ementa_delete
        celula = params[:celula]
        session[celula + "_ee"] = nil
        session[celula + "_ee_empty"] = 1


        render :json => [celula]
    end

    def ee_ementa_delete_refeicao
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

    def ee_ementa_extras
        refeicao = params[:refeicao]
        estado = params[:estado]
        session[refeicao+"_ee"] = estado
        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        if estado != "activo"
            if refeicao == "entradaa"
                @letter_array.each do |letter|
                    session[letter+"2_ee".to_s] = nil
                    session[letter + "2_ee_empty"] = 1
                end
                linha = 2
            elsif refeicao == "sobremesaa"
                @letter_array.each do |letter|
                    session[letter+"4_ee".to_s] = nil
                    session[letter + "4_ee_empty"] = 1
                end
                linha = 4
            elsif refeicao == "entradaj"
                @letter_array.each do |letter|
                    session[letter+"5_ee".to_s] = nil
                    session[letter + "5_ee_empty"] = 1
                end
                linha = 5
            elsif refeicao == "sobremesaj"
                @letter_array.each do |letter|
                    session[letter+"7_ee".to_s] = nil
                    session[letter + "7_ee_empty"] = 1
                end
                linha = 7
            end
        else
            linha = 0
        end

        render :json => [linha]
    end

    def ee_ementa_lock
        @letter_array = ["a","b","c", "d", "e", "f", "g"]

        if params[:celula] == "pa_lock"
            session[params[:celula]+"_ee"] = params[:estado]
            @letter_array.each do |letter|
                if !session[letter+"1_ee".to_s].blank?
                    session[letter+"1_ee".to_s][:lock] = params[:estado]
                end
            end
        elsif params[:celula] == "a_lock"
            session[params[:celula]+"_ee"] = params[:estado]
            @i = 2

            @letter_array.each do |letter|
                while @i < 5  do                   
                    if !session[letter+@i+"_ee".to_s].blank?
                        session[letter+@i+"_ee".to_s][:lock] = params[:estado]
                    end
                    @i +=1
                end
                @i = 2
            end
        elsif params[:celula] == "j_lock"
            session[params[:celula]+"_ee"] = params[:estado]
            @i = 5

            @letter_array.each do |letter|
                while @i < 8  do                   
                    if !session[letter+@i+"_ee".to_s].blank?
                        session[letter+@i+"_ee".to_s][:lock] = params[:estado]
                    end
                    @i +=1
                end
                @i = 5
            end
        else
            session[params[:celula]+"_ee"][:lock] = params[:estado]
        end

        render :json => [params[:celula], params[:estado]]
    end

    def ee_ementa_pessoas
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

    def ee_guardar_ementa
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

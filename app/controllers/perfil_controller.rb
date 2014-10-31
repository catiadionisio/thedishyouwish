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
    end

    def receitas_actividade
        @receitas = UserReceita.where(:user_id => current_user.id).order("created_at DESC")
        @ementas = Ementa.where(:user_id => current_user.id).order("created_at DESC")
        @receitas_guardadas = Receita.where("id IN (?)", params["id"].split(","))
        @restricoes = Restricao.where(:user_id => current_user.id).order("created_at")
    end

    def apagar_ementa
        ementa = Ementa.find(params[:id])

        if (!session["ementa"].blank?)
            if ementa.id == session["ementa"].to_i
                session["ementa"] = nil
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
end

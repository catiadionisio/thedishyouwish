class UserReceitaController < ApplicationController
    def fav

        if user_signed_in? 

            if fav = UserReceita.where(:user_id => current_user.id, :receita_id => params[:receitaid]).first
                fav.destroy

                if actividade = Actividade.where(:user_id => current_user.id, :accao => "remove", :tipo => "receita", :tipoid => params[:receitaid], :created_at =>  DateTime.now.beginning_of_day.. DateTime.now.end_of_day).first
                    actividade.save
                else
                    actividade = Actividade.new(:user_id => current_user.id, :accao => "remove", :tipo => "receita", :tipoid => params[:receitaid])
                    actividade.save
                end
            else
                current_user.user_receitas.create(:receita_id => params[:receitaid])

                if actividade = Actividade.where(:user_id => current_user.id, :accao => "add", :tipo => "receita", :tipoid => params[:receitaid], :created_at =>  DateTime.now.beginning_of_day.. DateTime.now.end_of_day).first
                    actividade.save
                else
                    actividade = Actividade.new(:user_id => current_user.id, :accao => "add", :tipo => "receita", :tipoid => params[:receitaid])
                    actividade.save
                end
            end

        else
            
        end

        render :json => params[:receitaid]
    end
end

class RatingsController < ApplicationController
    def rating

        if user_signed_in? 

            valor = params[:valor].to_i

            if rating = Rating.where(:user_id => current_user.id, :receita_id => params[:receitaid]).first
                rating.user_id = current_user.id
                rating.receita_id = params[:receitaid]
                rating.classificacao = valor
                rating.save
            else
                current_user.ratings.create(:receita_id => params[:receitaid], :classificacao => valor)
            end
        end

        rating_receita = Rating.average(:classificacao, :conditions => {:receita_id => params[:receitaid]})

        render :json => (rating_receita)
    end
end

class Receita < ActiveRecord::Base

	has_attached_file :imagem, 
	   :styles => { :mobile => "780x519#", :web => "1600x1064#", :list => "750x500#", :preview => "300x200#", :thumb => "100x70#", :pdf => "630x160#" }, 
	   :default_url => "/system/receitas/:style/missing.png",
	   :path => ":rails_root/public/system/receitas/imagens/:id/:style/:filename",
	   :url => "/system/receitas/imagens/:id/:style/:filename"
	validates_attachment_content_type :imagem, :content_type => /\Aimage\/.*\Z/

	has_many :confeccaos, :dependent => :destroy
	accepts_nested_attributes_for :confeccaos, :reject_if => :all_blank, :allow_destroy => true

	has_many :receita_tiporefeicaos
	has_many :tiporefeicaos, :through => :receita_tiporefeicaos
	accepts_nested_attributes_for :receita_tiporefeicaos, :allow_destroy => true, :reject_if => :all_blank
	accepts_nested_attributes_for :tiporefeicaos, :allow_destroy => true, :reject_if => :all_blank

	has_many :receita_ingredientes
	has_many :ingredientes, :through => :receita_ingredientes
	accepts_nested_attributes_for :receita_ingredientes, :allow_destroy => true, :reject_if => :all_blank
	accepts_nested_attributes_for :ingredientes, :allow_destroy => true, :reject_if => :all_blank

	has_many :receita_categorias
	has_many :categorias, :through => :receita_categorias
	accepts_nested_attributes_for :receita_categorias, :allow_destroy => true
	accepts_nested_attributes_for :categorias, :allow_destroy => true

	has_many :ementa_receitas
	has_many :ementas, :through => :ementa_receitas

	has_many :user_receitas
	has_many :users, :through => :user_receitas

	has_many :comentarios

	has_many :ratings
	accepts_nested_attributes_for :ratings, :allow_destroy => true

	def to_s
		nome
	end

	def self.search(search)
	  if search
	    where('nome LIKE ?', "%#{search}%")
	  else
	    scoped
	  end
	end

	def average_rating
	    @classificacao = 0
	    self.ratings.each do |rating|
	        @classificacao = @classificacao + rating.classificacao
	    end
	    @total = self.ratings.size
	    @classificacao.to_f / @total.to_f
	end

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

	def greatest_common_divisor(a, b)
	 while a%b != 0
	   a,b = b.round,(a%b).round
	 end 
	 return b
	end

end

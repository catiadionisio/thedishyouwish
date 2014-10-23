class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_attached_file :photo, 
    :styles => { :medium => "318x318#", :thumb => "100x100#" }, 
    :default_url => "/system/users/:style/missing.png",
    :path => ":rails_root/public/system/users/photos/:id/:style/:filename",
    :url => "/system/users/photos/:id/:style/:filename"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/


  def mediumFacebookImage
    "http://graph.facebook.com/#{self.uid}/picture?width=318&height=318"
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(nome:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                            datanasc:Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y'),
                          )
      end    end
  end


  before_validation { photo.clear if @remove_photo }

  def remove_photo
    @remove_photo ||= false
  end

  def remove_photo=(value)
    @remove_photo  = !value.to_i.zero?
  end

  def age(birthday)
    (Date.today - birthday).to_i / 365
  end

  has_many :ementas

  has_many :user_receitas
  has_many :receitas, :through => :user_receitas

  has_many :comentarios

  has_many :ratings

  has_many :restricaos
  has_many :ingredientes, :through => :restricaos

  def to_s
    nome
  end

end

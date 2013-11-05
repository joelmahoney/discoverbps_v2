class User < ActiveRecord::Base
	has_many :students, order: :first_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :name
  # attr_accessible :title, :body

	def self.find_or_create_from_oauth(auth, signed_in_resource=nil)
	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  if user.blank?
	  	puts "******************** user not found with omniauth hash - creating new user with the following info"
	  	puts "******************** name = #{auth.extra.raw_info.name}"
	  	puts "******************** provider = #{auth.provider}"
	  	puts "******************** email = #{auth.info.email}"
	    user = User.create!(name: auth.extra.raw_info.name,
	                         provider: auth.provider,
	                         uid: auth.uid,
	                         email: auth.info.email,
	                         password: Devise.friendly_token[0,20]
	                         )
	  end
	  puts "********************* user id = #{user.id}"
	  return user
	end
end

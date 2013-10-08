class StudentsController < ApplicationController

	def create
		if current_user.present?
			@student = Student.where(user_id: current_user.id, first_name: params[:student][:first_name], last_name: params[:student][:last_name]).first_or_create
		else
			@student = Student.where(session_id: session[:session_id], first_name: params[:student][:first_name], last_name: params[:student][:last_name]).first_or_create
		end

    respond_to do |format|
      if @student.update_attributes(params[:student])
        session[:current_student_id] = @student.id  	
      	street_number = URI.escape(params[:student][:street_number].try(:strip))
        street_name   = URI.escape(params[:student][:street_name].try(:strip))
        zipcode       = URI.escape(params[:student][:zipcode].try(:strip))
        
        @addresses = bps_api_connector("https://apps.mybps.org/WebServiceDiscoverBPSDEV/schools.svc/GetAddressMatches?StreetNumber=#{street_number}&Street=#{street_name}&ZipCode=#{zipcode}")[:List]
        
        format.js { render template: "students/address_verification" }
      else
        format.js { render template: "students/errors" }
      end
    end
  end

  def update
  	@student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        session[:current_student_id] = @student.id  	
      	street_number = URI.escape(params[:student][:street_number].try(:strip))
        street_name   = URI.escape(params[:student][:street_name].try(:strip))
        zipcode       = URI.escape(params[:student][:zipcode].try(:strip))
        
        @addresses = bps_api_connector("https://apps.mybps.org/WebServiceDiscoverBPSDEV/schools.svc/GetAddressMatches?StreetNumber=#{street_number}&Street=#{street_name}&ZipCode=#{zipcode}")[:List]
        
        format.js { render template: "students/address_verification" }
      else
        format.js { render template: "students/errors" }
      end
    end
  end

  def address_verification
    @student = Student.find(params[:id])
    home_coordinates = Geocoder.coordinates("#{params[:student][:street_number]} #{params[:student][:street_name]} #{params[:student][:zipcode]}")

    params[:student][:latitude] = home_coordinates[0]
    params[:student][:longitude] = home_coordinates[1]

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.js { render template: "students/iep" }         
      else
        format.js { render template: "students/errors" }
      end
    end
  end

  def iep
    @student = Student.find(params[:id])
    
    respond_to do |format|
      if @student.update_attributes(params[:student])
      	if (@student.preference_ids & PreferenceCategory.where(name: 'Specialized Language Support').first.preferences.collect {|x| x.id}).present?
	        format.js { render template: "students/ell" }
	      else
	        format.js { render template: "students/preferences" }
	      end
      else
        format.js { render template: "students/errors" }
      end
    end
  end

  def ell
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.js { render template: "students/preferences" }         
      else
        format.js { render template: "students/errors" }
      end
    end
  end

  def preferences
    @student = Student.find(params[:id])
    
    respond_to do |format|
      if @student.update_attributes(params[:student])
        session[:current_student_id] = @student.id    
	      format.html { redirect_to schools_url }
      end
    end
  end

  private

  def bps_api_connector(url)
    response = Faraday.new(:url => url, :ssl => {:version => :SSLv3}).get
    if response.body.present?
      MultiJson.load(response.body, :symbolize_keys => true)
    end
  end
end

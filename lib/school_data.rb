module SchoolData

  ##### UPDATE BASIC INFO #####

  def self.update_basic_info!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.basic_info(school.bps_id)
      school.update_attributes(name: response[:schname_23], latitude: response[:Latitude], longitude: response[:Longitude], api_basic_info: response) if response.present?
    end
  end

  ##### UPDATE AWARDS #####

  def self.update_awards!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.awards(school.bps_id)
      school.update_attributes(api_awards: response) if response.present?
    end
  end

  ##### UPDATE DESCRIPTIONS #####

  def self.update_descriptions!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.description(school.bps_id)
      school.update_attributes(api_description: response) if response.present?
    end
  end

  ##### UPDATE FACILITIES #####

  def self.update_facilities!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.facilities(school.bps_id)
      school.update_attributes(api_facilities: response) if response.present?
    end
  end

  ##### UPDATE GRADES #####

  def self.update_grades!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.grades(school.bps_id)
      school.update_attributes(api_grades: response) if response.present?
    end
  end

  ##### UPDATE HOURS #####

  def self.update_hours!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.hours(school.bps_id)
      school.update_attributes(api_hours: response) if response.present?
    end
  end

  ##### UPDATE LANGUAGES #####

  def self.update_languages!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.languages(school.bps_id)
      school.update_attributes(api_languages: response) if response.present?
    end
  end

  ##### UPDATE PARTNERS #####

  def self.update_partners!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.partners(school.bps_id)
      school.update_attributes(api_partners: response) if response.present?
    end
  end

  ##### UPDATE PHOTOS #####

  def self.update_photos!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.photos(school.bps_id)
      school.update_attributes(api_photos: response) if response.present?
    end
  end

  ##### UPDATE PREVIEW DATES #####

  def self.update_preview_dates!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.preview_dates(school.bps_id)
      school.update_attributes(api_preview_dates: response) if response.present?
    end
  end

  ##### UPDATE PROGRAMS #####

  def self.update_programs!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.programs(school.bps_id)
      school.update_attributes(api_programs: response) if response.present?
    end
  end

  ##### UPDATE SPORTS #####

  def self.update_sports!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.sports(school.bps_id)
      school.update_attributes(api_sports: response) if response.present?
    end
  end

  ##### UPDATE STUDENT SUPPORT #####

  def self.update_student_support!(school_id=nil)
    schools = self.find_schools(school_id)

    schools.each do |school|
      response = Webservice.student_support(school.bps_id)
      school.update_attributes(api_student_support: response) if response.present?
    end
  end


  private

  def self.find_schools(school_id)
    if school_id.present?
      School.where(id: school_id)
    else
      School.all
    end
  end

end

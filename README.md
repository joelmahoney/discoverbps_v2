School.all.each {|x| x.update_attributes(api_sports: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolGrades?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}
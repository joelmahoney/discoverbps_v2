IMPORT INSTRUCTIONS

# First, get all of the schools:

api_schools = MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolList?schyear=2014", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)

# Create Schools from the API response

api_schools.each {|x| School.create(bps_id: x[:sch], api_basic_info: x, name: x[:schname_23], latitude: x[:Latitude], longitude: x[:Longitude])}

###### Populate attributes from the API

###### :api_basic_info (convert to hash)

School.all.each {|x| x.update_attributes(api_basic_info: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchool?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchool?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}    

###### :api_awards

School.all.each {|x| x.update_attributes(api_awards: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolAwards?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolAwards?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_description (convert to hash)

School.all.each {|x| x.update_attributes(api_description: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolDescriptions?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolDescriptions?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_facilities (convert to hash)

School.all.each {|x| x.update_attributes(api_facilities: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolFacilities?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolFacilities?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_grades

School.all.each {|x| x.update_attributes(api_grades: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolGrades?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolGrades?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_hours (convert to hash)

School.all.each {|x| x.update_attributes(api_hours: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolHours?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolHours?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_languages

School.all.each {|x| x.update_attributes(api_languages: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolLanguages?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolLanguages?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_partners

School.all.each {|x| x.update_attributes(api_partners: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolPartners?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolPartners?schyear=2014&sch=#{x.bps_id}&TranslationLanguage=", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_photos

School.all.each {|x| x.update_attributes(api_photos: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolPhotos?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolPhotos?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}

###### :api_sports (convert to hash

School.all.each {|x| x.update_attributes(api_sports: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolSports?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolSports?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}



######## FACILITIES

School.all.each {|x| x.update_attributes(api_facilities: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolFacilities?schyear=2013&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}

failed: [1252, 1320, 1060, 1163, 1272, 1271, 1160, 1161, 1301, 1303, 4150, 1502, 1102, 1365, 4120, 4340, 1355, 1302, 4321, 4172, 1504, 1360, 1501, 1370, 2030, 1310, 1315, 4054, 1290, 1304, 4010, 4431, 2050, 1305, 4445, 1250, 4430, 2090, 1251, 1345, 2270, 1100, 1270, 1330, 4571, 1503]

[4590, 1101, 1340, 4100, 2360, 4200, 1020, 4291, 1030, 4650, 4323, 1070, 4201, 4450, 4173, 1430, 4460, 4031, 4084, 1215, 4022, 4052, 4680, 2950, 1420, 1991, 4580, 4350, 1040, 4272, 1010, 4391, 1210, 1292, 4270, 4410, 4610, 4285, 4621, 4322, 4261, 1103, 2140, 4055, 1291, 4250, 4390, 4561, 4178, 4440, 1410, 4160, 1064, 4630, 2040, 1265, 4210, 4345, 1171, 4345, 4690, 4400, 4231, 4640, 1254, 4361, 4081, 4530, 1450, 1195, 2450, 4123, 4541, 4671, 1325, 4130, 1253, 4370, 4230, 2190, 1050, 4070, 1294, 1080, 4381, 4600, 1293, 1053, 4053, 4592, 1200, 4121, 2010, 1256, 1285, 4171, 4311, 4290, 4401, 1459, 4661, 4192, 1162, 2440, 1230, 4030, 4190, 4531, 1260, 2260, 4242, 4283, 1470, 1990, 1120, 4360, 4543, 4062, 4061, 1440, 4331, 4570, 4560, 1460, 4140, 4033, 4113, 4240, 4151, 4193, 4080, 4260, 1140, 4082, 4620, 4280, 1441].each {|x| School.where(bps_id: x).first.update_attributes(api_facilities: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolFacilities?schyear=2013&sch=#{x}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}

######## GRADES

School.all.each {|x| x.update_attributes(api_grades: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolGrades?schyear=2014&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}

failed: [1272, 1271, 1060, 1160, 1301, 1303, 1302, 4172, 1310, 1304, 4431, 1305, 4445, 1250, 4430, 2270, 1100, 1270]

[4200, 4391, 4100, 1502, 1294, 4230, 1171, 4173, 1340, 1163, 1102, 1991, 1030, 1020, 1070, 4291, 1040, 4650, 2030, 4610, 4323, 4400, 4201, 4450, 1210, 1080, 1252, 4361, 1325, 4130, 4022, 4150, 4084, 4285, 4381, 4340, 1420, 4178, 1292, 4052, 4680, 1293, 1430, 2190, 4270, 4350, 4440, 4410, 4272, 4621, 1101, 1050, 4081, 4261, 1365, 1103, 4322, 4160, 2140, 4120, 4055, 1315, 4250, 1291, 4345, 1290, 1010, 4210, 1064, 4345, 4630, 1265, 2040, 1253, 4690, 1501, 4541, 4054, 4231, 1053, 4640, 1195, 1504, 1254, 1360, 1370, 4530, 4070, 1450, 2450, 4123, 4671, 4010, 4370, 4600, 1320, 2050, 4590, 4460, 4031, 4390, 4053, 4592, 1200, 4121, 1215, 2010, 1256, 1285, 2360, 4171, 4311, 4561, 4290, 2090, 4401, 2950, 1459, 1251, 4661, 4192, 1162, 1355, 2440, 1230, 4030, 4190, 1161, 4531, 1260, 2260, 1410, 1345, 4242, 4283, 1470, 1990, 1120, 4360, 4543, 4321, 4062, 4061, 1440, 4580, 1330, 4331, 4570, 4571, 4560, 1460, 4140, 4033, 4113, 4240, 4151, 4193, 4080, 4260, 1503, 1140, 4082, 4620, 4280, 1441].each {|x| School.where(bps_id: x).first.update_attributes(api_grades: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolGrades?schyear=2014&sch=#{x}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}

######## LANGUAGES

[1441]

[1252, 1502, 1163, 1060, 1272, 1271, 4250, 1160, 1320, 1355, 1161, 4123, 1301, 1303, 4150, 2360, 4200, 1162, 1102, 1365, 4120, 4340, 1103, 2140, 4178, 4440, 1302, 4321, 2190, 1050, 4172, 1360, 4592, 1504, 1501, 1101, 4650, 4323, 1070, 4201, 4450, 4460, 4084, 1215, 4022, 4680, 2950, 1370, 1420, 4350, 1040, 4272, 1010, 4391, 4031, 2030, 1210, 1310, 1292, 4270, 4410, 1315, 4610, 4285, 4621, 4054, 4322, 4261, 4055, 1291, 4390, 4561, 1410, 4160, 1064, 1290, 4630, 1304, 2040, 4010, 1265, 1171, 4530, 1450, 4431, 1195, 2050, 2450, 4671, 1253, 4370, 4230, 4070, 1294, 1080, 4381, 4600, 4053, 1200, 4121, 2010, 1256, 4290, 4401, 1459, 4661, 4192, 2440, 1230, 4331, 1305, 4445, 1250, 1285, 4171, 4311, 4430, 2090, 1251, 4690, 4400, 4030, 4190, 4531, 1260, 2260, 1345, 4242, 4283, 1470, 1990, 1120, 4360, 2270, 4590, 4543, 4062, 4061, 1440, 1100, 1270, 1330, 4570, 4571, 4560, 1460, 4140, 4033, 4113, 4240, 4151, 4193, 4080, 4260, 1503, 1140, 4082, 4620, 4280, 1991, 4580, 4231, 4541, 1340, 4640, 4081, 4052, 4345, 4130, 1293, 1325, 1053, 4100, 4345, 1020, 4210, 1254, 4361, 4291, 1430, 1030, 4173].each {|x| School.where(bps_id: x).first.update_attributes(api_languages: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolLanguages?schyear=2013&sch=#{x}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}


School.all.each {|x| x.update_attributes(api_basic_info: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchool?schyear=2013&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true))}

School.all.each {|x| x.update_attributes(api_photos: MultiJson.load(Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolPhotos?schyear=2013&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body, :symbolize_keys => true)) if Faraday.new(:url => "https://apps.mybps.org/WebServiceDiscoverBPSv1.10/Schools.svc/GetSchoolPhotos?schyear=2013&sch=#{x.bps_id}", :ssl => {:version => :SSLv3}).get.body.present?}
require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

require 'clockwork'
include Clockwork

handler do |job|
  puts "Running #{job}"
end

# 9 UTC = 3am EST and 12am PST
every(1.day, 'Update school basic info', at: '09:00') 		    { SchoolData.delay.update_basic_info! }
every(1.day, 'Update school awards', at: '09:00') 				    { SchoolData.delay.update_awards! }
every(1.day, 'Update school descriptions', at: '09:00')       { SchoolData.delay.update_descriptions! }
every(1.day, 'Update school facilities', at: '09:00') 		    { SchoolData.delay.update_facilities! }
every(1.day, 'Update school grades', at: '09:00') 				    { SchoolData.delay.update_grades! }
every(1.day, 'Update school hours', at: '09:00') 					    { SchoolData.delay.update_hours! }
every(1.day, 'Update school languages', at: '09:00')	 		    { SchoolData.delay.update_languages! }
every(1.day, 'Update school partners', at: '09:00')           { SchoolData.delay.update_partners! }
every(1.day, 'Update school photos', at: '09:00') 				    { SchoolData.delay.update_photos! }
every(1.day, 'Update school preview dates', at: '09:00') 		  { SchoolData.delay.update_preview_dates! }
every(1.day, 'Update school programs', at: '09:00') 				  { SchoolData.delay.update_programs! }
every(1.day, 'Update school sports', at: '09:00') 				    { SchoolData.delay.update_sports! }
every(1.day, 'Update school student support', at: '09:00')    { SchoolData.delay.update_student_support! }

every(1.hour, 'Store searches json') { StoredSearch.first_or_create.update_attributes(json: Student.order(:last_name).to_json(only: [ :grade_level, :latitude, :longitude, :zipcode, :ell_language, :sped_needs, :awc_invitation, :preferences_count  ], methods: :created_at_date)) }

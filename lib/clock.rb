require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

require 'clockwork'
include Clockwork

handler do |job|
  puts "Running #{job}"
end

# 9 UTC = 3am EST and 12am PST
every(1.hour, 'Update school basic info') 	{ SchoolData.delay.update_basic_info! }
every(1.hour, 'Update school awards') 			{ SchoolData.delay.update_awards! }
every(1.hour, 'Update school descriptions') { SchoolData.delay.update_descriptions! }
every(1.hour, 'Update school facilities') 	{ SchoolData.delay.update_facilities! }
every(1.hour, 'Update school grades') 			{ SchoolData.delay.update_grades! }
every(1.hour, 'Update school hours') 				{ SchoolData.delay.update_hours! }
every(1.hour, 'Update school languages') 		{ SchoolData.delay.update_languages! }
every(1.hour, 'Update school partners') 		{ SchoolData.delay.update_partners! }
every(1.hour, 'Update school photos') 			{ SchoolData.delay.update_photos! }
every(1.hour, 'Update school sports') 			{ SchoolData.delay.update_sports! }	
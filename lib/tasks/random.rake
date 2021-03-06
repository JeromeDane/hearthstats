task :ListEmails => :environment do
	users = User.all
	users.each do |u|
		puts u.email
	end
end

task :FixProfiles => :environment do
	users = User.includes(:profile).where(guest: nil).where( :profiles => { :user_id => nil } )
	counter = 0
	users.each do |u|
		profile = Profile.new
    profile.user_id = u.id
    profile.save
    counter += 1
	end
	puts "#{counter} profiles fixed"
end

task :DeleteGuests => :environment do
	count = User.where(:guest => true).count
	User.destroy_all(:guest => true)

	puts "#{count} Guests Deleted"
end

task :FixPatchGames => :environment do
	past_con = Constructed.where("created_at between ? and ?", Time.at(1386633600).to_datetime, Date.current)
	past_arena_run = ArenaRun.where("created_at between ? and ?", Time.at(1386633600).to_datetime, Date.current)
	past_con.update_all(:patch => "current")
	puts "#{past_con.count} Constructed Games Fixed"

	past_arena_run.update_all(:patch => "current")
	puts "#{past_arena_run.count} Constructed Games Fixed"

	puts "Games Fixed"
end
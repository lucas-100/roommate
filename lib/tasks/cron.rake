desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
 
 
 # add the signups into the actual database
 max_houses = 10
 counter = (House.count > 0) ? House.count : 0
   while counter <= max_houses
     s = Signup.first
   
     unless s.nil?
      puts "Processing #{s.name} -- #{s.email}..."
   
       params = {:person => {:name => s.name, :email => s.email}}
   
       pass =  Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}/#{params[:person][:email]}"))[0..7]
       params[:person][:password] = pass
       params[:person][:password_confirmation] = pass
   
       @house = House.create({:name => "New House"})
       @person = @house.people.new(params[:person])
   
       if @person.save
         s.destroy
         SignupMailer.new_house_and_person(@person, pass).deliver
         puts "...Done!"
       else
         @house.destroy
         puts "#{@person.errors} for #{@person.id}"
       end
     
     end
    
     counter += 1
    end
  
end
json.interview do
	json.id @interview.id
	json.interview_date @interview.interview_date
	json.start_time @interview.start_time
	json.end_time @interview.end_time	

	json.interviewer do 
		json.name @interview.interviews_users.where(:role => 0).first.user.name
		json.email @interview.interviews_users.where(:role => 0).first.user.email
	end

	json.candidate do 
		json.name @interview.interviews_users.where(:role => 1).first.user.name
		json.email @interview.interviews_users.where(:role => 1).first.user.email
	end
end
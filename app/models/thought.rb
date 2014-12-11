class Thought < ActiveRecord::Base

	def as_json(options=nil)
		super(only: [:id, :title, :author, :score, :permalink])
	end

end

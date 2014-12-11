class Dream < ActiveRecord::Base

	def as_json(options=nil)
		super(only: [:id, :dream])
	end

end

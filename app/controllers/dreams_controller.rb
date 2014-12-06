class DreamsController < ApplicationController

	def index
		dreams = Dream.all
		render json: dreams
	end

end

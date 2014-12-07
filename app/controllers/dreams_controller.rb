class DreamsController < ApplicationController

	def index
		dreams = Dream.all
		render json: dreams.as_json(only: [:id, :dream])
	end

	private

	def options
  	defaults.merge(params)
  end

  def defaults
  	{"dream" => ""}
  end

end

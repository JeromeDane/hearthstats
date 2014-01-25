module Api
	module V1
		class ArenasController < ApplicationController
			before_filter :restrict_access_api, :get_user_api
			respond_to :json

			def show
				render :json => "hello"
			end

			def new
				# Required params:
				# :oppclass, :win, :gofirst
				# Optional params:
				# :notes

				arena_run = ArenaRun.where(user_id: @user[0].id, complete: false).last
				@arena = Arena.new(@req)
				@arena.arena_run_id = arena_run.id
				@arena.userclass = arena_run.userclass
				if @arena.save
	        render json: "Success\n"
	      else
	        render json: @arena.errors
	      end
			end
		end
	end
end
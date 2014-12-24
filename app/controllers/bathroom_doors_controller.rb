class BathroomDoorsController < ApplicationController

  def edit
    @door = Door.find(params[:id])
  end


end

class LabelsController < ApplicationController
  def index
    @labels = Label.all
  end

  def new
    @labels = Label.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def destoroy
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end 
end

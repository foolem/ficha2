class ImportationsController < ApplicationController
  before_action :bar_define

  def groups
  end

  def courses
  end

  def import_groups
    Importation.import_groups(params[:file])

    redirect_to root_url, notice: 'Products imported.'
  end

  def import_courses
    Importation.import_courses(params[:file])

    redirect_to root_url, notice: 'Products imported.'
  end

  private

    def bar_define
      session[:page] = "Importation"
    end




end

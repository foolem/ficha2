class HelpController < ApplicationController
  before_action :bar_define

  def index
  end

  def bar_define
    session[:page] = "help"
  end
end

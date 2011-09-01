require 'net/https'
require 'uri'
require 'icalendar'

class IcalImportController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:id])
    @ical_settings = IcalSetting.find_by_project_id(@project)
  end
end


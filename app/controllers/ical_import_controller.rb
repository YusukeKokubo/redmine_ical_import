require 'net/https'
require 'uri'
require 'icalendar'

class IcalImportController < ApplicationController
  unloadable

  before_filter :find_project
  before_filter :find_ical_setting

  def index
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def find_ical_setting
    @ical_settings = IcalSetting.find_all_by_project_id(@project)
  end
end


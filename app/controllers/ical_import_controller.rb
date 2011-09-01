require 'net/https'
require 'uri'
require 'icalendar'

class IcalImportController < ApplicationController
  unloadable

  before_filter :find_project, :only => :index
  before_filter :find_ical_setting, :only => :index

  def index
  end

  def update
    @ical_setting = IcalSetting.find(params[:id])
    IcalImporter.import @ical_setting.id

    redirect_to :controller => 'ical_import', :action => "index", :id => @ical_setting.project
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def find_ical_setting
    @ical_settings = IcalSetting.find_all_by_project_id(@project)
  end
end


require 'net/https'
require 'uri'
require 'icalendar'

include Icalendar

class IcalImportSettingsController < ApplicationController
  unloadable
  layout 'base'
  menu_item :ical

  def show
    @project = Project.find(params[:id])
    @ical_settings = IcalSetting.find_by_project_id(@project)
    @ical_setting = IcalSetting.new
  end

  def lock
    @ical_setting = IcalSetting.find(params[:id])
    @ical_setting.status = IcalSetting::STATUS_LOCK
    @ical_setting.save!

    redirect_to :controller => 'projects', :action => "settings", :id => @ical_setting.project, :tab => 'ical_import'
  end

  def active
    @ical_setting = IcalSetting.find(params[:id])
    @ical_setting.status = IcalSetting::STATUS_ACTIVE
    @ical_setting.save!

    redirect_to :controller => 'projects', :action => "settings", :id => @ical_setting.project, :tab => 'ical_import'
  end

  def new
    @project = Project.find(params[:id])
    @ical_setting = IcalSetting.new
    @ical_setting.attributes = params[:ical_setting]
    @ical_setting.project = @project
    @ical_setting.status = IcalSetting::STATUS_ACTIVE

    url = URI.parse(@ical_setting.url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.start {
      response = http.get(url.request_uri)
      cals = Icalendar::parse(response.body)
      cal = cals[0]
      @ical_setting.name = cal.x_wr_calname
    }

    @ical_setting.save!

    redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'ical_import'
  end
end


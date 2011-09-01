# $Id: hudson_settings_controller.rb 559 2010-10-03 08:35:08Z toshiyuki.ando1971 $
# To change this template, choose Tools | Templates
# and open the template in the editor.

class IcalImportSettingsController < ApplicationController
  unloadable
  layout 'base'
  menu_item :ical

  def show
    @project = Project.find(params[:id])
    @ical_settings = IcalSetting.find_by_project_id(@project)
    @ical_setting = IcalSetting.new
  end

  def new
    @project = Project.find(params[:id])
    @ical_setting = IcalSetting.new
    @ical_setting.attributes = params[:ical_setting]
    @ical_setting.project = @project
    @ical_setting.save!

    redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'ical'
  end
end


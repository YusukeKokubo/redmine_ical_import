
#ENV['RAILS_ENV'] ||= 'production'

require 'icalendar'

require 'date'
require 'kconv'
require 'net/https'
require 'uri'
require 'logger'

class IcalImporter
  include Icalendar
  
  class << self
    def import(cond = :all)
      logger = Logger.new(File.join(File.dirname(__FILE__), "../../../../log/ics_import.log"))
      logger.level = Logger::DEBUG

      cals = nil
      IcalSetting.find_all_by_id(cond).each do |setting|

        next if setting.project.archived?
        next if setting.lock?
        logger.info "ics import from #{setting.inspect}"

        uri = URI.parse(setting.url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.start {
        response = http.get(uri.request_uri)
          cals = Icalendar::parse(response.body)
        }
        cal = cals[0]
        cal.events.each do |event|
          # MEMO: TZIDがなければ強制的に日本時間に強制しているけどほんとはVTIMEZONEを元に補正すべき
          start_date = event.dtstart
          start_date = start_date.new_offset(Rational(9, 24)) if start_date.respond_to? :new_offset and start_date.ical_params["TZID"].nil?
          end_date = event.dtend
          end_date = end_date.new_offset(Rational(9, 24)) if end_date.respond_to? :new_offset and end_date.ical_params["TZID"].nil?
          last_modified = event.last_modified
          last_modified = last_modified.new_offset(Rational(9, 24)) if last_modified and last_modified.ical_params["TZID"].nil?

          ical_event = IcalEvent.find_by_uid event.uid
          issue = ical_event.issue if ical_event
          issue = Issue.new unless issue

          next if last_modified.nil? and not issue.new_record?
          next if ical_event and last_modified and ical_event.updated_at >= last_modified
          if start_date < DateTime.now
            next unless last_modified
            next if last_modified < DateTime.now
          end

          logger.info "create event #{event.inspect}"

          issue.init_journal(setting.user) unless issue.new_record?
          issue.tracker = setting.tracker
          issue.subject = event.summary
          issue.description = <<EOS
* start:
** #{start_date.strftime("%Y-%m-%d %H:%M:%S")}
* end:
** #{end_date.strftime("%Y-%m-%d %H:%M:%S")}
* location:
** #{event.location}

#{event.description}
EOS
          issue.project = setting.project
          issue.author = setting.user
          issue.assigned_to = setting.user
          issue.start_date = start_date
          issue.due_date = end_date
          issue.save!
          logger.info "saved issue : #{issue.inspect}"

          ical_event = IcalEvent.new unless ical_event
          ical_event.uid = event.uid
          ical_event.issue = issue
          ical_event.ical_setting = setting
          ical_event.start_date = start_date
          ical_event.due_date = end_date
          ical_event.save!
          logger.info "saved event : #{ical_event.inspect}"

        end
      end
      logger.info "ics import finished."
    end
  end
end

if __FILE__ == $0
  require "rubygems"
  require File.join(File.dirname(__FILE__), "../../../../config/environment")
  #IcalImporter.import([1])
  IcalImporter.import
end


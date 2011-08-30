
#ENV['RAILS_ENV'] ||= 'production'

require "rubygems"
require 'icalendar'

require File.join(File.dirname(__FILE__), "../../../../config/environment")
require 'date'
require 'kconv'
require 'net/https'
require 'uri'

include Icalendar

class IcalImporter

  class << self
    def import
      cals = nil
      uri = URI.parse("hoge.ics")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.start {
      response = http.get(uri.request_uri)
        cals = Icalendar::parse(response.body)
      }
      cal = cals[0]
      cal.events.each do |event|
        start_date = event.dtstart
        start_date = start_date.new_offset(Rational(9, 24))
        end_date = event.dtend
        end_date = end_date.new_offset(Rational(9, 24))
        puts "start   " + start_date.to_s
        puts "end:    " + end_date.to_s
        puts "uid:    " + event.uid.to_s
        puts "summary:" + event.summary.to_s
        puts "desc:   " + event.description.to_s

        issue = Issue.new
        issue.tracker_id = 39
        issue.subject = event.summary
        issue.description = event.description
        issue.project_id = 228
        issue.save
      end
    end
  end
end

if __FILE__ == $0
  IcalImporter.import
end


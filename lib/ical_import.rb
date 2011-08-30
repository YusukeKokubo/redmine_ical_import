
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
        last_modified = event.last_modified
        last_modified = last_modified.new_offset(Rational(9, 24))

        rel = UidRelation.find_by_uid event.uid
        issue = rel.issue if rel
        issue = Issue.new unless issue

        next if issue and rel and rel.updated_at >= last_modified

        issue.init_journal(User.find(3))
        issue.tracker_id = 39
        issue.subject = event.summary
        issue.description = event.description
        issue.project_id = 228
        issue.author_id = 3
        issue.start_date = start_date
        issue.due_date = end_date
        issue.save!

        unless rel
          rel = UidRelation.new
          rel.uid = event.uid
          rel.issue = issue
          rel.save!
        end
      end
    end
  end
end

if __FILE__ == $0
  IcalImporter.import
end


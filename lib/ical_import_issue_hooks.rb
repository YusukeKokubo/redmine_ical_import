# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class IcalImportIssueHooks < Redmine::Hook::ViewListener
  def view_issues_show_details_bottom(context = { })
    project = context[:project]
    return '' unless project
    unless User.current.allowed_to?({:controller => 'ical_import', :action => 'index'}, project)
      return ''
    end
    controller = context[:controller]
    return '' unless controller
    
    request = context[:request]
    issue = context[:issue]

    ical_event = IcalEvent.find_by_issue_id(issue.id)
    return '' unless ical_event
<<EOS
<tr>
  <td><b>#{l(:ical_field_start_datetime)}:</b></td>
  <td colspan="3">
    #{ical_event.start_date.strftime("%Y-%m-%d %H:%M:%S")}
  </td>
</tr>
<tr>
  <td><b>#{l(:ical_field_due_datetime)}:</b></td>
  <td colspan="3">
    #{ical_event.due_date.strftime("%Y-%m-%d %H:%M:%S")}
  </td>
</tr>
<tr>
  <td><b>#{l(:ical_field_location)}:</b></td>
  <td colspan="3">
    #{ical_event.location}
  </td>
</tr>
EOS
  end
end


module IcalImportHelper
  def event_date(rel, issue)
    if issue.start_date == issue.due_date
<<EOS
<td colspan="2" style="text-align: center;">#{issue.start_date}, #{rel.start_date.strftime("%H:%M")} - #{rel.due_date.strftime("%H:%M")}</td>
EOS
    else
<<EOS
<td style="text-align: center;">#{issue.start_date}</td>
<td style="text-align: center;">#{issue.due_date}</td>
EOS
    end
  end
end


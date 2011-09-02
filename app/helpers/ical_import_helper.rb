module IcalImportHelper
  def event_date(issue)
    if issue.start_date == issue.due_date
<<EOS
<td colspan="2" style="text-align: center;">#{issue.start_date}</td>
EOS
    else
<<EOS
<td style="text-align: center;">#{issue.start_date}</td>
<td style="text-align: center;">#{issue.due_date}</td>
EOS
    end
  end
end


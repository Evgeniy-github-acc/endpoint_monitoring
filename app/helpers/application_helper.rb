module ApplicationHelper
  def render_status(status)
    case status
    when "operational"
      color_class = "text-emerald-500 bg-emerald-100/60 dark:bg-gray-800"
      label = "Operational"
    when "degraded"
      color_class = "text-yellow-500 bg-yellow-100/60 dark:bg-gray-800"
      label = "Degraded"
    when "incident"
      color_class = "text-red-500 bg-red-100/60 dark:bg-gray-800"
      label = "Incident"
    else
      color_class = "text-gray-500 bg-gray-100/60 dark:bg-gray-800"
      label = "Unknown"
    end

    content_tag(:div, class: "inline-flex items-center px-3 py-1 rounded-full gap-x-2 #{color_class}") do
      content_tag(:h2, label, class: "text-sm font-normal")
    end
  end

  def render_history_day(history_day)
    case history_day.status
    when "operational"
      color_class = "bg-emerald-500"
    when "degraded"
      color_class = "bg-yellow-500"
    when "incident"
      color_class = "bg-red-500"
    else
      color_class = "bg-gray-500"
    end

    content_tag(:button, class: "has-tooltip h-10 w-2 rounded-full flex-1 #{color_class}") do
      content_tag(:div, class: "tooltip rounded shadow-lg p-1 bg-gray-100 text-blue-600 -mt-28") do
        content_tag(:div) do
          content_tag(:div) { "Date: #{history_day.date}" } +
            content_tag(:div) { "Average response time: #{history_day.average_response_time}" } +
            content_tag(:div) { "Failed requests: #{history_day.failed_requests_count}" } +
            content_tag(:div) { "Day status: #{history_day.status}" }
        end
      end
    end
  end
end

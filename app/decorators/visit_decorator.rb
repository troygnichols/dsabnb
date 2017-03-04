class VisitDecorator < Draper::Decorator
  decorates :visit
  delegate_all

  def date
    date = "#{start_and_end_dates}"
  end

  def short_details
    location << " (#{start_and_end_dates})"
  end
end

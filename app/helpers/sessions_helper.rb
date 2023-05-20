module SessionsHelper
  def formatted_duration(total_minutes)
    total_minutes = total_minutes.round
    hours = total_minutes / (60)
    minutes = (total_minutes) % 60
    seconds = total_minutes * 60 % 60
    [hours, minutes, seconds].map do |t|
      t.round.to_s.rjust(2, '0')
    end.join(':')
  end
end
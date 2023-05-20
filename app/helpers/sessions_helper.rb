module SessionsHelper
  def formatted_duration(total_seconds)
    total_seconds = total_seconds.round
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    [hours, minutes, seconds].map do |t|
      t.round.to_s.rjust(2, '0')
    end.join(':')
  end
end

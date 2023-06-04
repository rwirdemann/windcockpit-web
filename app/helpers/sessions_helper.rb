module SessionsHelper
  def formatted_duration(total_seconds)
    return "00:00:00" if total_seconds.nil?

    total_seconds = total_seconds.round
    hours = total_seconds / (60 * 60)
    minutes = (total_seconds / 60) % 60
    seconds = total_seconds % 60
    [hours, minutes, seconds].map do |t|
      t.round.to_s.rjust(2, '0')
    end.join(':')
  end

  def formatted_distance(total_meters)
    return "0 km" if total_meters.nil?
    kilometer = (total_meters / 1000).round(2)
    "#{kilometer} km"
  end

  def formatted_speed(speed_in_ms)
    return "0 km/h" if speed_in_ms.nil?
    speed = (speed_in_ms * 3.6).round(2)
    "#{speed} km/h"
  end
end

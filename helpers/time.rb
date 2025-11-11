class DateTime
    def today?
        self.to_date == Date.today
    end
end

class Time
    def today?
        self.to_date == Date.today
    end
end

def formatted_minutes(minutes)
    hours = minutes / 60
    minutes = minutes % 60
    return "#{hours}h #{minutes}m"
end
class TimeSpan
    def initialize(from_time, to_time = nil)
        @from_time = from_time.is_a?(Time) ? from_time : Time.parse(from_time)
        @to_time = to_time == nil ? nil : Time.parse(to_time)
    end

    def from
        return @from_time
    end

    def to
        return @to_time
    end

    def end
        @to_time = Time.now
    end

    def active?
        return @to_time == nil
    end

    def finished?
        return @to_time != nil
    end

    def duration # in minutes
        to_time = finished? ? self.to : Time.now
        return ((to_time - self.from) / 60).to_i
    end

    def to_json
        return { from: self.from, to: self.to, duration: self.duration, }
    end

    def debug
        "from: #{self.from}; to: #{self.to}; duration: #{self.duration}"
    end
end
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

    def today?
        [@from_time, @to_time].compact.any? { |time| time.today? }
    end

    def duration # in minutes
        to_time = finished? ? self.to : Time.now
        return ((to_time - self.from) / 60).to_i
    end

    def today_duration # in minutes
        return 0 unless today?
        from_time = self.from.today? ? self.from : Time.parse("#{Date.today.to_s} 00:00")
        to_time = finished? ? self.to : Time.now
        return ((to_time - from_time) / 60).to_i
    end

    def to_json
        return { from: self.from, to: self.to, duration: self.duration, }.to_json
    end

    def debug
        "from: #{self.from}; to: #{self.to}; duration: #{self.duration}"
    end
end
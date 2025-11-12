class Task
    attr_reader :id, :name, :description, :time_spans

    def initialize(file_path)
        @id = nil
        @file_path = file_path
        @time_spans = []

        if File.file?(file_path)
            @yaml_data = YAML.load_file(file_path)
            @id = @yaml_data['id'].to_s
            @name = @yaml_data['name'].to_s
            @description = @yaml_data['description'].to_s
            @created_at = Time.parse(@yaml_data['created_at'])
            @time_span_count = @yaml_data['time_span_count'].to_i
            if @time_span_count > 0
                @from_times = @yaml_data['from_times']
                @to_times = @yaml_data['to_times']
            else
                @from_times = []
                @to_times = []
            end
            @time_span_count.times do |ix|
                @time_spans << TimeSpan.new(@from_times[ix], @to_times[ix])
            end
        end
    end

    def uri_id
        return self.id.sub('TASK_', '')
    end

    def name_preview
        return @name if @name.size < 32
        return @name[0, 30] + '...'
    end

    def latest_time # for relevance sorting
        return @created_at if @time_span_count == 0
        times = [@created_at] + @time_spans.map { |ts| [ts.from, ts.to] }
        return times.flatten.compact.max
    end

    def duration
        @time_spans.sum { |time_span| time_span.duration }
    end

    def today_duration
        @time_spans.sum { |time_span| time_span.today_duration }
    end

    def active?
        return @time_spans.any? && @time_spans.last.active?
    end

    def started?
        return @time_spans.any?
    end

    def toggle
        if self.active?
            # end current latest time span
            @time_spans.last.end
        else
            # create new time span
            @time_spans << TimeSpan.new(Time.now)
            @time_span_count += 1
        end
        self.save
        return @time_spans.last
    end

    def save
        from_times = @time_spans.map { |ts| ts.from.to_s }
        to_times = @time_spans.map { |ts| ts.to.to_s }
        to_times << nil unless to_times.size == @time_span_count
        @yaml_data = {
            'id' => @id,
            'name' => @name,
            'description' => @description,
            'created_at' => @created_at.to_s,
            'time_span_count' => @time_span_count,
            'from_times' => from_times,
            'to_times' => to_times,
        }
        File.write(@file_path, @yaml_data.to_yaml)
    end
end
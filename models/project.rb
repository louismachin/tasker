class Project
    attr_reader :id, :name, :tasks

    def initialize(file_path)
        @id = nil
        @tasks = []

        if File.file?(file_path)
            @yaml_data = YAML.load_file(file_path)
            @id = @yaml_data['id'].to_s
            @name = @yaml_data['name'].to_s
        end

        load_tasks
    end

    def uri_id
        return self.id.sub('PROJECT_', '')
    end

    def duration
        return @tasks.sum { |task| task.duration }
    end

    def today_duration
        return @tasks.sum { |task| task.today_duration }
    end

    def load_tasks
        @tasks = []
        for file_path in Dir["./data/#{self.id}/*.yml"] do
            @tasks << Task.new(file_path)
        end
    end
end
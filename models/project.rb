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

    def load_tasks
        @tasks = []
        for file_path in Dir["./data/#{self.id}/*.yml"] do
            @tasks << Task.new(file_path)
        end
    end
end
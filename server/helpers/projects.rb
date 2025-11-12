$all_projects_cache = nil

def get_all_projects
    return $all_projects_cache if $all_projects_cache
    result = {}
    for file_path in Dir['./data/PROJECT_*.yml'] do
        project = Project.new(file_path)
        result[project.id] = project
    end
    $all_projects_cache = result
    return result
end

def clear_projects_cache
    $all_projects_cache = nil
end

def get_all_tasks
    return get_all_projects.values.map { |project| project.tasks }.flatten
end

def get_sorted_tasks
    return get_all_tasks.sort { |a, b| b.latest_time <=> a.latest_time }
end

def get_task_by_id(task_id)
    get_all_tasks.each { |task| return task if task.id == task_id }
    return nil
end

def get_project_by_name(project_name)
    get_all_projects.values.each { |project| return project if project.name == project_name }
    return nil
end

def create_project(name)
    project_id = "PROJECT_#{rand(999999999)}"
    yaml_data = {
        'id' => project_id,
        'name' => name,
        'created_at' => Time.now.to_s,
    }
    FileUtils.mkdir('./data') unless File.directory?("./data")
    File.write("./data/#{project_id}.yml", yaml_data.to_yaml)
    clear_projects_cache
end

def create_task(project, name, description)
    task_id = "TASK_#{rand(999999999)}"
    yaml_data = {
        'id' => task_id,
        'name' => name,
        'description' => description,
        'created_at' => Time.now.to_s,
        'time_span_count' => 0,
    }
    FileUtils.mkdir('./data') unless File.directory?("./data")
    FileUtils.mkdir("./data/#{project.id}") unless File.directory?("./data/#{project.id}")
    File.write("./data/#{project.id}/#{task_id}.yml", yaml_data.to_yaml)
    clear_projects_cache
end

def get_today_duration
    return get_all_projects.values.sum { |project| project.today_duration }
end

helpers do
    def get_today_duration
        return get_all_projects.values.sum { |project| project.today_duration }
    end
end
$all_projects_cache = nil

def get_all_projects
    return $all_projects_cache if $all_projects_cache
    result = {}
    for file_path in Dir['./data/*.yml'] do
        project = Project.new(file_path)
        result[project.id] = project
    end
    $all_projects_cache = result
    return result
end

def get_all_tasks
    return get_all_projects.values.map { |prj| prj.tasks }.flatten
end

def get_sorted_tasks
    return get_all_tasks.sort { |a, b| b.latest_time <=> a.latest_time }
end

def get_task_by_id(task_id)
    get_all_tasks.each { |task| return task if task.id == task_id }
    return nil
end
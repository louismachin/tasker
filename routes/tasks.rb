get '/project/new' do
    protected!
    @copy = $env.default_copy
    @projects = get_all_projects.values
    @sorted_tasks = get_sorted_tasks
    erb :new_project, locals: { copy: @copy }
end

post '/project/new' do
    protected!
    data = JSON.parse(request.body.read)
    project_name = data['name']
    project = create_project(project_name)
    content_type :json
    status 200
    { success: true, project: project.to_json }.to_json
end

get '/task/new' do
    protected!
    @copy = $env.default_copy
    @projects = get_all_projects.values
    @sorted_tasks = get_sorted_tasks
    erb :new_task, locals: { copy: @copy }
end

post '/task/new' do
    protected!
    data = JSON.parse(request.body.read)
    task_name = data['name']
    task_description = data['description']
    project_name = data['project_name']
    project = get_project_by_name(project_name)
    task = create_task(project, task_name, task_description)
    content_type :json
    status 200
    { success: true, task: task.to_json }.to_json
end

get '/task/:task_id/toggle.json' do
    protected!
    task_id = params[:task_id]
    task = get_task_by_id(task_id)
    puts "task_id=#{task_id};\ttask=#{task.inspect}"
    if task
        time_span = task.toggle
        content_type :json
        status 200
        { success: true, time_span: time_span.to_json, active: time_span.active? }.to_json
    else
        content_type :json
        status 401
        { success: false, error: 'No task for ID' }.to_json
    end
end

get '/task/:task_id' do
    protected!
    @copy = $env.default_copy
    @projects = get_all_projects.values
    @sorted_tasks = get_sorted_tasks
    task_id = params[:task_id]
    @task = get_task_by_id(task_id)
    erb :index, locals: { copy: @copy }
end
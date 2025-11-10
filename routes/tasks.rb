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
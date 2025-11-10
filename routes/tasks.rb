get '/task/:task_id/toggle.json' do
    task_id = params[:task_id]
    task = get_task_by_id(task_id)
    if task
        time_span = task.toggle
        { success: true, time_span: time_span.to_json, active: time_span.active? }.to_json
    else
        { success: false, error: 'No task for ID' }.to_json
    end
end
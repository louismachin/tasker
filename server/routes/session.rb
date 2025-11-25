helpers do
    def apply_xauth_token(token)
        response.set_cookie($env.xauth_cookie_name, value: token, path: '/', max_age: '3600')
    end

    def is_valid_attempt?(attempt)
        unless $env.uses_xauth?
            return $env.check_attempt(attempt)
        else
            user, token = $env.check_xauth_attempt(attempt)
            return false if user == nil
            apply_xauth_token(token)
            return true
        end
    end

    def is_logged_in?
        unless $env.uses_xauth?
            cookie = request.cookies[$env.cookie_name]
            api_key = params['api_key']
            if api_key
                $env.check_api_key(api_key)
            elsif cookie
                $env.check_cookie(cookie)
            else
                false
            end
        else
            puts "is_logged_in?\trequest.cookies=#{request.cookies}"
            xauth_cookie = request.cookies[$env.xauth_cookie_name]
            user, token = $env.check_xauth_cookie(xauth_cookie)
            return false if user == nil
            apply_xauth_token(token)
            return true
        end
    end

    def protected!
        redirect '/login' unless is_logged_in?
    end

    def current_user
        cookie = request.cookies[$env.cookie_name]
        $env.cookie_user(cookie)
    end
end

get '/login' do
    @copy = $env.default_copy
    erb :login, { copy: @copy }
end

post '/login' do
    data = JSON.parse(request.body.read)
    attempt = { username: data['username'], password: data['password'] }
    user = is_valid_attempt?(attempt)
    if user
        token = $env.new_token(user)
        response.set_cookie($env.cookie_name, value: token, path: '/', max_age: '3600')
        content_type :json
        status 200
        { success: true, token: token }.to_json
    else
        content_type :json
        status 401
        { success: false, error: "Invalid password" }.to_json
    end
end

get '/logout' do
    token = request.cookies[$env.cookie_name]
    $env.given_tokens.delete(token) if token
    response.delete_cookie($env.cookie_name, path: '/')
    redirect '/login'
end

ENV_FILE_PATH = 'environment.yml'

Cache = Struct.new(:cached_at, :data, :expiry) do
    def expired?
        Time.now - cached_at > expiry
    end
end

User = Struct.new(:username)

class Environment
    attr_reader :data
    attr_accessor :given_tokens

    def initialize
        if File.file?(ENV_FILE_PATH)
            require 'yaml'
            @data = YAML.load_file(ENV_FILE_PATH)
            @given_tokens = {}
        else
            puts "ERROR: 'environment.yml' file is missing..."
            exit
        end
    end

    def port
        @data.dig('port')
    end

    def cookie_name
        @data.dig('cookie_name')
    end
    
    def default_copy
        {
            title: @data.dig('title'),
            licensee: @data.dig('licensee'),
        }
    end

    def new_token(user)
        token = Array.new(12) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
        @given_tokens[token] = user
        return token
    end
    
    def check_attempt(attempt)
        username, password = attempt[:username], attempt[:password]
        user = @data.dig('users', username)
        if user && (user['password'] == password)
            return User.new(username)
        else
            return nil
        end
    end

    def check_cookie(cookie)
        @given_tokens.keys.include?(cookie)
    end

    def check_api_key(api_key)
        all_api_keys = @data.dig('users').map { |_, data| data.dig('api_keys') }.flatten
        return all_api_keys.include?(api_key)
    end

    def cookie_user(cookie)
        @given_tokens[cookie]
    end

    # xauth methods

    def build_user(username)
        User.new(username)
    end

    def uses_xauth?
        @data.include?('xauth_agent')
    end

    def xauth_cookie_name
        begin
            body = simple_get_body('https://xauth.shukra.dev/api/cookie_name.json')
            puts "xauth_cookie_name\tbody=#{body}"
            return body['cookie_name']
        rescue
            return nil
        end
    end

    def check_xauth_attempt(attempt) # [user, token]
        username, password = attempt[:username], attempt[:password]
        base_uri = 'https://xauth.shukra.dev/api/login.json'
        body = { username: username, password: password, }
        response = simple_post_json(base_uri, {}, body)
        puts "check_xauth_attempt\t#{response.body}"
        if response.code == '200'
            body = JSON.parse(response.body)
            username = body['username']
            token = body['token']
            user = build_user(username)
            return user, token
        else
            return nil
        end
        return nil
    end

    def check_xauth_cookie(cookie)
        base_uri = 'https://xauth.shukra.dev/api/validate.json'
        response = simple_post_json(base_uri, {}, { token: cookie, })
        puts "check_xauth_cookie\t#{response.body}"
        if response.code == '200'
            body = JSON.parse(response.body)
            username = body['username']
            token = body['token']
            user = build_user(username)
            return user, token
        else
            return nil
        end
        return nil
    end
end

$env = Environment.new
require "kemal"
require "../config/database"
require "./models/user"
require "./auth"
require "./models/todo"

module Training::Todo::Api
  VERSION = "0.1.0"

  post "/register" do |context|
    username = context.params.json["username"].as(String)
    password = context.params.json["password"].as(String)
    display_name = context.params.json["display_name"].as(String)

    if User.register(username, password, display_name)
      context.response.content_type = "application/json"
      context.response.print %({"message": "User Registration Completed"})
    else
      context.response.status_code = 400
      context.response.content_type = "application/json"
      context.response.print %({"error": "User Registration Failed"})
    end
  end

  post "/login" do |env|
    username = env.params.json["username"].as(String)
    password = env.params.json["password"].as(String)

    if user = User.authenticate(username, password)
      token = Auth.generate_token(user.id)
      env.response.content_type = "application/json"
      env.response.print %({
        "token": "#{token}",
        "user_id": #{user.id},
        "display_name": "#{user.display_name}"
      })
    else
      env.response.status_code = 401
      env.response.content_type = "application/json"
      env.response.print %({"error": "Invalid credentials"})
    end
  end

  before_all "/todos/*" do |env|
    begin
      token = env.request.headers["Authorization"]? || ""
      user_id = Auth.decode_token(token)
      if user_id.nil?
        halt env, 401, %({"error": "UnAuthorized"})
      else
        add_context_storage_type(Int64)
        env.set "user_id", user_id
      end
    rescue
      halt env, 500, %({"error": "Something went wrong"})
    end
  end

  get "/todos" do |env|
    user_id = env.get("user_id").as(Int64)
    todos = Todos.get_all_todos(user_id)
    env.response.content_type = "application/json"
    env.response.print Todos.to_json(todos)
  end

  post "/todos" do |env|
    user_id = env.get("user_id").as(Int64)
    title = env.params.json["title"].as(String)
    description = env.params.json["description"].as(String)

    if Todos.add_todo(user_id, title, description)
      env.response.content_type = "application/json"
      env.response.print %({"message": "Todo added"})
    else
      env.response.status_code = 400
      env.response.content_type = "application/json"
      env.response.print %({"error": "Failed to add Todo"})
    end
  end

  put "/todos/:id" do |env|
    user_id = env.get("user_id").as(Int64)
    todo_id = env.params.url["id"].to_i64
    title = env.params.json["title"].as(String)
    description = env.params.json["description"].as(String)

    if Todos.update_todo(todo_id, user_id, title, description)
      env.response.content_type = "application/json"
      env.response.print %({"message": "Todo Updated"})
    else
      env.response.status_code = 400
      env.response.content_type = "application/json"
      env.response.print %({"error": "Failed to update Todo"})
    end
  end

  delete "/todos/:id" do |env|
    user_id = env.get("user_id").as(Int64)
    todo_id = env.params.url["id"].to_i64

    if Todos.delete_todo(todo_id, user_id)
      env.response.content_type = "application/json"
      env.response.print %({"message": "Todo Deleted"})
    else
      env.response.status_code = 400
      env.response.content_type = "application/json"
      env.response.print %({"error": "Failed to delete Todo"})
    end
  end
end

Kemal.run

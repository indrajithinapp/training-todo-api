require "sqlite3"

class Todos
  property id : Int64
  property user_id : Int64
  property title : String
  property description : String

  def initialize(id : Int64 = 0, user_id : Int64 = 0, title : String = "", description : String = "")
    @id = id
    @user_id = user_id
    @title = title
    @description = description
  end

  def self.get_all_todos(user_id : Int64) : Array(Todos)
    result = DB_M.query "SELECT * FROM todos WHERE user_id = ?", user_id
    todos = [] of Todos
    result.each do
      todos << Todos.new(
        result.read(Int),
        result.read(Int),
        result.read(String),
        result.read(String)
      )
    end
    todos
  end

  def self.add_todo(user_id : Int64, title : String, description : String) : Bool
    query = "INSERT INTO todos (user_id, title, description) VALUES (?, ?, ?)"
    result = DB_M.exec(query, user_id, title, description)
    return false unless result
    return true
  end

  def self.update_todo(todo_id : Int64, user_id : Int64, title : String, description : String) : Bool
    query = "UPDATE todos set title = ?, description = ? WHERE id = ? AND user_id = ?"
    result = DB_M.exec(query, title, description, todo_id, user_id)
    return false unless result
    return true
  end

  def self.delete_todo(todo_id : Int64, user_id : Int64) : Bool
    query = "DELETE FROM todos WHERE id = ? AND user_id = ?"
    result = DB_M.exec(query, todo_id, user_id)
    return false unless result
    return true
  end

  def to_hash : Hash(String, String | Int64)
    {
      "id"          => id.to_i64,
      "title"       => title,
      "description" => description,
    }
  end

  def self.to_json(todos : Array(Todos)) : String
    todos.map(&.to_hash).to_json
  end
end

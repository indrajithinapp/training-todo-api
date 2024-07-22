require "sqlite3"
require "crypto/bcrypt/password"

class User
  property id : Int64
  property username : String
  property password : String
  property display_name : String

  def initialize(id : Int64 = 0, username : String = "", password : String = "", display_name : String = "")
    @id = id
    @username = username
    @password = password
    @display_name = display_name
  end

  def self.register(username : String, password : String, display_name : String) : Bool
    hashed_password = Crypto::Bcrypt::Password.create(password).to_s
    begin
      DB_M.exec "INSERT INTO users (username, password, display_name) VALUES (?, ?, ?)", username, hashed_password, display_name
      true
    rescue ex
      puts ex
      false
    end
  end

  def self.authenticate(username : String, password : String) : User?
    query = "SELECT * FROM users WHERE username = ?"
    result = DB_M.query(query, username)
    return nil unless result

    result.each do
      id = result.read(Int)
      name = result.read(String)
      pass = result.read(String)
      dname = result.read(String)
      user = User.new(id, name, pass, dname)
      return user if Crypto::Bcrypt::Password.new(user.password).verify(password)
    end
    nil
  end
end

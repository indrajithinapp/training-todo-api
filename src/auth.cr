require "jwt"

module Auth
  SECRET = "REACT_TRAINING_2024"

  def self.generate_token(user_id : Int64) : String
    JWT.encode({"user_id" => user_id}, SECRET, JWT::Algorithm::HS256)
  end

  def self.decode_token(token : String) : Int64?
    payload, _ = JWT.decode(token, SECRET, JWT::Algorithm::HS256)
    payload["user_id"].as_i64
  end
end

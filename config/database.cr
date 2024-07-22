require "sqlite3"

DB_M = DB.open "sqlite3:./db.sqlite"

DB_M.exec "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT, display_name TEXT)"
DB_M.exec "CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, title TEXT, description TEXT)"

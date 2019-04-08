class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    newstudent = self.new
    newstudent.id = row[0]
    newstudent.name = row[1]
    newstudent.grade = row[2]
    newstudent
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students 
    SQL
    DB[:conn].execute(sql).each do |row|
      @@all << self.new_from_db(row)
    end 
    @@all
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students 
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

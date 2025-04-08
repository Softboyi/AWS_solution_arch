CREATE DATABASE employees;

USE employees;

CREATE TABLE staff (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  position VARCHAR(50)
);

INSERT INTO staff (name, position) VALUES
('John Doe', 'Manager'),
('Jane Smith', 'Developer'),
('Sam Brown', 'Analyst');

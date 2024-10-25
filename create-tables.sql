-- Create your database tables here. Alternatively you may use an ORM
-- or whatever approach you prefer to initialize your database.
CREATE TABLE example_table (id SERIAL PRIMARY KEY, some_int INT, some_text TEXT);
INSERT INTO example_table (some_int, some_text) VALUES (123, 'hello');

CREATE TABLE margin_table (id SERIAL PRIMARY KEY, margin_top INT, margin_bottom INT, margin_left INT, margin_right INT);
INSERT INTO margin_table (margin_top, margin_bottom, margin_left, margin_right) VALUES (-1, -1, -1, -1);

CREATE TABLE padding_table (id SERIAL PRIMARY KEY, padding_top INT, padding_bottom INT, padding_left INT, padding_right INT);
INSERT INTO padding_table_table (padding_top, padding_bottom, padding_left, padding_right) VALUES (-1, -1, -1, -1);


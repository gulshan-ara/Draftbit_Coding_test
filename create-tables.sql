-- Create your database tables here. Alternatively you may use an ORM
-- or whatever approach you prefer to initialize your database.
CREATE TABLE example_table (id SERIAL PRIMARY KEY, some_int INT, some_text TEXT);
INSERT INTO example_table (some_int, some_text) VALUES (123, 'hello');

CREATE TABLE margin_padding_table (id SERIAL PRIMARY KEY, margin_top TEXT, margin_bottom TEXT, margin_left TEXT, margin_right TEXT, padding_top TEXT, padding_bottom TEXT, padding_left TEXT, padding_right TEXT);
INSERT INTO margin_padding_table (margin_top, margin_bottom, margin_left, margin_right, padding_top, padding_bottom, padding_left, padding_right) VALUES ('auto', 'auto', 'auto', 'auto', 'auto', 'auto',  'auto',  'auto');




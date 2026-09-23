This is a simple periodic table database and query script.

periodic_table.sql is a postgreSQL program which dumps a database called periodic_table into your desired postgreSQL server, and for the sake of the "DROP DATABASE periodic_table", "CREATE DATABASE periodic_table" and "\c periodic_table" statements, it is recommended that you run this via a psql statement on the command line using the '-f' option.

element.sh is a simple Bash script designed to take as input either an atomic number, atomic symbol or element name and return a statement of the input element's properties via a query of the periodic_table database.

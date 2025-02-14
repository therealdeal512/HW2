# In this assignment, you'll be using the domain model from hw1 (found in the hw1-solution.sql file)
# to create the database structure for "KMDB" (the Kellogg Movie Database).
# The end product will be a report that prints the movies and the top-billed
# cast for each movie in the database.

# To run this file, run the following command at your terminal prompt:
# `rails runner kmdb.rb`

# Requirements/assumptions
#
# - There will only be three movies in the database – the three films
#   that make up Christopher Nolan's Batman trilogy.
# - Movie data includes the movie title, year released, MPAA rating,
#   and studio.
# - There are many studios, and each studio produces many movies, but
#   a movie belongs to a single studio.
# - An actor can be in multiple movies.
# - Everything you need to do in this assignment is marked with TODO!
# - Note rubric explanation for appropriate use of external resources.

# Rubric
#
# There are three deliverables for this assignment, all delivered within
# this repository and submitted via GitHub and Canvas:
# - Generate the models and migration files to match the domain model from hw1.
#   Table and columns should match the domain model. Execute the migration
#   files to create the tables in the database. (5 points)
# - Insert the "Batman" sample data using ruby code. Do not use hard-coded ids.
#   Delete any existing data beforehand so that each run of this script does not
#   create duplicate data. (5 points)
# - Query the data and loop through the results to display output similar to the
#   sample "report" below. (10 points)
# - You are welcome to use external resources for help with the assignment (including
#   colleagues, AI, internet search, etc). However, the solution you submit must
#   utilize the skills and strategies covered in class. Alternate solutions which
#   do not demonstrate an understanding of the approaches used in class will receive
#   significant deductions. Any concern should be raised with faculty prior to the due date.

# Submission
#
# - "Use this template" to create a brand-new "hw2" repository in your
#   personal GitHub account, e.g. https://github.com/<USERNAME>/hw2
# - Do the assignment, committing and syncing often
# - When done, commit and sync a final time before submitting the GitHub
#   URL for the finished "hw2" repository as the "Website URL" for the 
#   Homework 2 assignment in Canvas

# Successful sample output is as shown:

# Movies
# ======

# Batman Begins          2005           PG-13  Warner Bros.
# The Dark Knight        2008           PG-13  Warner Bros.
# The Dark Knight Rises  2012           PG-13  Warner Bros.

# Top Cast
# ========

# Batman Begins          Christian Bale        Bruce Wayne
# Batman Begins          Michael Caine         Alfred
# Batman Begins          Liam Neeson           Ra's Al Ghul
# Batman Begins          Katie Holmes          Rachel Dawes
# Batman Begins          Gary Oldman           Commissioner Gordon
# The Dark Knight        Christian Bale        Bruce Wayne
# The Dark Knight        Michael Caine         Alfred
# The Dark Knight        Heath Ledger          Joker
# The Dark Knight        Aaron Eckhart         Harvey Dent
# The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
# The Dark Knight Rises  Christian Bale        Bruce Wayne
# The Dark Knight Rises  Gary Oldman           Commissioner Gordon
# The Dark Knight Rises  Tom Hardy             Bane
# The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
# The Dark Knight Rises  Anne Hathaway         Selina Kyle

# Delete existing data, so you'll start fresh each time this script is run.
Studio.destroy_all
Movie.destroy_all
Actor.destroy_all
Role.destroy_all

# Generate models and migration files according to the domain model
#rails generate model Studio name:string
#rails generate model Movie title:string year_released:integer rated:string studio:references
#rails generate model Actor name:string
#rails generate model Role movie:references actor:references character_name:string

# Run database migrations to apply the changes
#rails db:migrate


# Insert data into the database that reflects the sample data shown above.
studio = Studio.create(name: "Warner Bros.")

batman_begins = Movie.create(title: "Batman Begins", year_released: 2005, rated: "PG-13", studio: studio)
the_dark_knight = Movie.create(title: "The Dark Knight", year_released: 2008, rated: "PG-13", studio: studio)
the_dark_knight_rises = Movie.create(title: "The Dark Knight Rises", year_released: 2012, rated: "PG-13", studio: studio)

actors = {
  "Christian Bale" => "Bruce Wayne",
  "Michael Caine" => "Alfred",
  "Liam Neeson" => "Ra's Al Ghul",
  "Katie Holmes" => "Rachel Dawes",
  "Gary Oldman" => "Commissioner Gordon",
  "Heath Ledger" => "Joker",
  "Aaron Eckhart" => "Harvey Dent",
  "Maggie Gyllenhaal" => "Rachel Dawes",
  "Tom Hardy" => "Bane",
  "Joseph Gordon-Levitt" => "John Blake",
  "Anne Hathaway" => "Selina Kyle"
}

actors.each do |name, character|
  actor = Actor.find_or_create_by(name: name)
  Role.create(movie: batman_begins, actor: actor, character_name: character) if ["Christian Bale", "Michael Caine", "Liam Neeson", "Katie Holmes", "Gary Oldman"].include?(name)
  Role.create(movie: the_dark_knight, actor: actor, character_name: character) if ["Christian Bale", "Michael Caine", "Heath Ledger", "Aaron Eckhart", "Maggie Gyllenhaal"].include?(name)
  Role.create(movie: the_dark_knight_rises, actor: actor, character_name: character) if ["Christian Bale", "Gary Oldman", "Tom Hardy", "Joseph Gordon-Levitt", "Anne Hathaway"].include?(name)
end

# Prints a header for the movies output
puts "Movies"
puts "======"
puts ""
Movie.order(:year_released).each do |movie|
  puts "#{movie.title.ljust(25)} #{movie.year_released}  #{movie.rated}  #{movie.studio.name}"
end

# Prints a header for the cast output
puts "\nTop Cast"
puts "========"
puts ""
Role.includes(:movie, :actor).joins(:movie).order("movies.year_released, roles.id").each do |role|
  puts "#{role.movie.title.ljust(25)} #{role.actor.name.ljust(20)} #{role.character_name}"
end

# Terminal Commands to Run Before Executing Script
# ------------------------------------------------
#rails db:drop db:create db:migrate
#rails generate model Studio name:string
#rails generate model Movie title:string year_released:integer rated:string studio:references
#rails generate model Actor name:string
#rails generate model Role movie:references actor:references character_name:string
#rails db:migrate
#rails runner kmdb.rb

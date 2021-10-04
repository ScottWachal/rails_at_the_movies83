require "csv"

Page.delete_all
Movie.delete_all
ProductionCompany.delete_all

filename = Rails.root.join("db/top_movies.csv")

puts "Loading Movies from the CSV file: #{filename}"

csv_data = File.read(filename)
movies = CSV.parse(csv_data, headers: true, encoding: "utf-8")

movies.each do |m|
  # puts m["original_title"]
  production_company = ProductionCompany.find_or_create_by(name: m["production_company"])

  if production_company && production_company.valid?
    movie = production_company.movies.create(
      title:        m["original_title"],
      year:         m["year"],
      duration:     m["duration"],
      description:  m["description"],
      average_vote: m["avg_vote"]
    )

    # movie && movie.valid?
    puts "Invalid movie #{m['original_title']}" unless movie&.valid?
  else
    puts "Invalid Production Company: #{m['production_company']} for movie: #{m['original_title']}"
  end
end

Page.create(
  title:     "Contact Us",
  content:   "If you like this site and want to chat about the project or the data, email me at: obviously_fake@email.com",
  permalink: "contact"
)

Page.create(
  title:     "About the data",
  content:   "The data powering this website was stolen (err.. provided) by an IMDB Kaggle dataset!",
  permalink: "about_the_data"
)

puts "Created #{ProductionCompany.count} Production Companies"
puts "Created #{Movie.count} movies."

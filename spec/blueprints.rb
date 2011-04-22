require 'machinist/mongoid'
require 'sham'
require 'faker'

Blog.blueprint do
  title            { Faker::Lorem.words(5) * " " }
  desired_slug     { "my-blog" }
  description      { "My incredibly insightful blog" }
end

Comment.blueprint do
  author       { Faker::Name.name }
  author_email { Faker::Internet.email }
  content      { Faker::Lorem.words(5) * " " }
end

Post.blueprint do
  title             { Faker::Lorem.words(5) * " " }
  summary           { Faker::Lorem.words(5) * " " }
  content           { Faker::Lorem.words(5) * " " }
  slug              { Faker::Lorem.words(5) * "-" }
  publication_date  { Time.zone.now }
  state             { 'published' }
end

Topic.blueprint do
  name               { Faker::Lorem.words(5) * " " }
  description        { Faker::Lorem.words(5) * " " }
  short_description  { Faker::Lorem.words(5) * " " }
end


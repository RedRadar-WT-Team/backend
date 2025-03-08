# RepRadar

## Who Am I/What am I?
Hey there! 👋

Welcome to RepRadar, the ultimate tool for staying informed about your local representatives and the latest Executive Orders! 🚀

🔍 What can I do for you?

• I can fetch the top 5 most recent Executive Orders straight from the Federal Register and keep you in the loop with current policies! 📰

• By entering your zip code, I’ll identify your local representatives with up-to-date info about them. Need to know who’s representing you? I’ve got you covered!

Whether I pull data directly from the database or fetch real-time info from external APIs, I make sure you always get the most relevant and accurate details. 🔄

Check me out and stay connected with your government—I’m here to make it easy! 💥

![Alt Text](https://i.gifer.com/6Fj8.gif)

## Notable Links
### [Link to Front End Application](https://github.com/RedRadar-WT-Team/frontend)
### [Project Board - Figma](https://www.figma.com/board/wzG4kiosKh0WlHoW9DrUKE/Rep-Radar-Planning?node-id=11-329&t=YiR7D5Q3NUzvoDyy-0)
### [BackLog](https://elysabward.atlassian.net/jira/software/projects/RR2025/boards/1/backlog?selectedIssue=RR2025-5)
### [Federal Register API](https://www.federalregister.gov/)
### [5 Calls](https://api.5calls.org)

## Prerequisites
### Software and Tools Required

1. ### Ruby
   • Version Required: Ruby 3.2.2
   • Installation: Install Ruby using a version manager like rbenv or rvm, or install directly from Ruby’s official site.

2. ### Rails
   • Version Required: Rails 7.1.5.1 or later
   • Installation: Install Rails globally after installing Ruby:
     ```sh
     gem install rails
     ```

3. ### Bundler
   • Version: Bundler is used to manage Ruby gems.
   • Installation:   
     ```sh
     gem install bundler
     ```

4. ### PostgreSQL
   • Version: PostgreSQL 12.x.x (or the version you’re using)
   • Installation: You can install PostgreSQL by following the official installation guide.
     ```sh
     psql --version
     ```

5. ### RSpec
   • Version: For testing.
   • Installation: Include rspec-rails gem in the Gemfile and run:
     ```sh
     bundle install
     ```

6. ### Command to run tests
   ```sh
   bundle exec rspec
   ```

7. ### Postman
   • Version: Latest stable version of Postman  
   • Installation: Download from Postman.

8. ### Heroku
   • Version: Latest version of Heroku CLI
   • Installation: Follow the installation instructions from Heroku’s website: [LINK HERE](https://devcenter.heroku.com/articles/getting-started-with-ruby)

## Running the Tests

1. ### Install Testing Dependencies
   - Before running tests, ensure that all necessary gems are installed. Run:
     ```sh
     bundle install
     ```

2. ### Run Specific Test Suite
   - To run specific tests, use:
     ```sh
     bundle exec rspec spec/requests/api/v1/executive_orders_request_spec.rb
     ```

## Features

### Executive Orders Endpoints
- Fetches all Executive Orders from the current administration.
- Retrieves the five most recent Executive Orders.
- Retrieves a specific Executive Order by document number.
- Allows users to save and unsave Executive Orders.

### Representatives Endpoints
- Fetches representatives based on a given ZIP code.
- Queries representatives from external APIs or the database.
- Provides detailed representative information including party affiliation and contact details.

## API Endpoints Overview
### Executive Orders
- **GET** `/api/v1/executive_orders` - Retrieves a list of executive orders.
- **GET** `/api/v1/executive_orders/recent` - Fetches the five most recent executive orders.
- **GET** `/api/v1/executive_orders/:document_number` - Fetches details for a specific executive order.
- **POST** `/api/v1/executive_orders_users` - Saves an executive order for a user.
- **DELETE** `/api/v1/executive_orders_users/destroy` - Removes a saved executive order.

### Representatives
- **GET** `/api/v1/representatives/search?db=false&query=ZIP_CODE` - Retrieves representatives based on ZIP code.

## Authors

- ### [Elysa Ward](https://github.com/elysableu)
- ### [Kevin Newland](https://github.com/kevin-newland)
- ### [Patrick Shim](https://github.com/pshim17)
- ### [Kristin Weiland](https://github.com/KMPWeiland)
- ### [Jillian Bleggi](https://github.com/jbleggi)
- ### [Jonathan Atkins](https://github.com/Jonathan-Atkins)


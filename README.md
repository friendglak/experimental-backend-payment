# Ride-Hailing API

This project is a simple ride-hailing API that allows riders to create a payment method, request rides, and drivers to finish rides calculating the total amount to be paid. This API is built with Ruby and Sinatra framework.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Ruby
- Bundler
- PostgreSQL

### Setup

1. Clone the repository:

```bash
git clone <repository-url>
```

2. Navigate to the project root directory:

```bash
cd <repository-name>
```

3. Install the dependencies:

```bash
bundle install
```

4. Set up the database:

   - Create a **.env** file in the root directory based on **.env.** sample.
     - Should be something like:
       ```
       DATABASE_URL=postgres://postgres:password@localhost/name_of_your_database
       TEST_DATABASE_URL=postgres://postgres:password@localhost/(name_of_your_database)_test
       SANDBOX_URL=https://sandbox.{?}.co/v1
       PUBLIC_KEY=pub_test_xxxxxxxxxx
       PRIVATE_KEY=prv_test_xxxxxxxxx
       ```
       - Remember that the PUBLIC_KEY and PRIVATE_KEY are from the sandbox environment.
   - Create the databases and apply migrations:
     - ```bash
       sequel -m db/migrate -E $DATABASE_URL
       ```

### Running the code locally

To run the application locally, use:
`    ruby app.rb`

### Running the tests

To run the tests, use:
`rspec`

_You must be sure that you are connected to the test database to run the test._

### Deployment

To deploy this application, you can follow these steps tailored to your preferred platform (e.g., Heroku, AWS). This guide will briefly cover Heroku deployment.

#### Deploying to Heroku

1. Create a Heroku account and install the Heroku CLI.

1. Log in to Heroku through the CLI:

   ```bash
   heroku login
   ```

1. Create a new Heroku app:

   ```bash
   heroku create
   ```

1. Add a PostgreSQL database to the app:

   ```bash
    heroku addons:create heroku-postgresql:hobby-dev
   ```

1. Deploy your application to Heroku:

   ```bash
   git push heroku main
   ```

1. Run database migrations on Heroku:

   ```bash
   heroku run sequel -m db/migrate $DATABASE_URL
   ```

Replace $HEROKU_POSTGRESQL_COLOR_URL with your Heroku database URL environment variable name (usually something like HEROKU_POSTGRESQL_AMBER_URL).

# LandChecker Backend 🚀

LandChecker is a robust Rails API designed for property search and management. This backend service handles property data, user watchlists, and saved searches, providing a high-performance foundation for real estate applications.

## 🛠 Prerequisites

Ensure you have the following installed on your local machine:

- **Ruby**: `3.4.9` (as specified in `.ruby-version`)
- **Rails**: `8.1.3`
- **PostgreSQL**: Ensure the Postgres service is running locally.

## 🚀 Local Setup

Follow these steps to get your development environment up and running:

### 1. Clone the repository

```bash
git clone https://github.com/zen0529/landchecker-backend.git
cd landchecker-backend
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Database Setup

This project uses PostgreSQL. Make sure your database service is active, then run:

```bash
bin/rails db:prepare
bin/rails db:seed
```

_Note: The `db:seed` command will populate your database with sample properties, users, and watchlist items._

### 4. Run the Application

Start the Rails server on port 3000:

```bash
rails s -p 3000
```

Alternatively, you can use the setup script which installs dependencies and prepares the database automatically:

```bash
bin/setup
```

## 🧪 Running Tests

Maintain code quality by running the test suite:

```bash
bin/rails test
```

## 🔑 Development Credentials

You can use the following accounts to test the API in development:

| Email                 | Password   | Role                 |
| :-------------------- | :--------- | :------------------- |
| `tester123@email.com` | `test1234` | Admin / Default User |

## 🏗 Key Technologies

- **Framework**: Ruby on Rails 8.1.3 (API Mode)
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens) & BCrypt
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **Real-time**: Solid Cable
- **Data Generation**: Faker (for seeds)

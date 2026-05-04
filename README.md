# LandChecker Backend 🚀

LandChecker is a robust Rails API designed for property search and management. This backend service handles property data, user watchlists, and real-time notifications via WebSockets, providing a high-performance foundation for real estate applications.

## 🛠 Prerequisites

Ensure you have the following installed on your local machine:

- **Ruby**: `3.4.9` (as specified in `.ruby-version`)
- **Rails**: `8.1.3`
- **PostgreSQL**: Ensure the Postgres service is running locally.
- **Redis**: `7.x` — required for ActionCable WebSocket broadcasting.

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

### 3. Start Redis

ActionCable uses Redis as its pub/sub adapter for real-time WebSocket broadcasts. Make sure Redis is running before starting the Rails server.

**Ubuntu / WSL:**
```bash
sudo apt update && sudo apt install redis-server -y
sudo service redis start
```

**macOS (Homebrew):**
```bash
brew install redis
brew services start redis
```

Verify Redis is running:
```bash
redis-cli ping
# Expected output: PONG
```

> Redis runs on `localhost:6379` by default. The `config/cable.yml` is already configured to use this in development — no extra setup needed.

### 4. Database Setup

This project uses PostgreSQL. Make sure your database service is active, then run:

```bash
bin/rails db:prepare
bin/rails db:seed
```

_Note: The `db:seed` command will populate your database with sample properties, users, and watchlist items._

### 5. Run the Application

You will need **two terminals** running simultaneously:

```bash
# Terminal 1 — Rails server
rails s -p 3000

# Terminal 2 — (optional) Redis, if not running as a background service
redis-server
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

## For testing websocket(do this in rails console)

### Find a watchlisted property
item = WatchlistItem.includes(:property).first
property = item.property

puts "Property: #{property.title}"
puts "Current price: #{property.price}"

### Change the price
old_price = property.price
property.update!(price: old_price - 50_000)

puts "New price: #{property.price}"

note: ensure the watchlisted property is wishlisted into the logged account

## 🏗 Key Technologies

- **Framework**: Ruby on Rails 8.1.3 (API Mode)
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens) & BCrypt
- **Real-time**: ActionCable (WebSockets) backed by Redis
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **Data Generation**: Faker (for seeds)

## ⚙️ Environment Variables

> In development, Redis defaults to `redis://localhost:6379/1` and no env var is needed.

# Empire Sync

A Ruby on Rails application that syncs Empire Flippers marketplace listings to HubSpot CRM deals automatically once per day.

## What it does

1. Fetches all "For Sale" listings from the [Empire Flippers Public API](https://empireflippers.com/marketplace-api/)
2. Stores listing data in a PostgreSQL database
3. Creates a corresponding Deal in HubSpot CRM for each listing
4. Runs automatically once per day via Sidekiq background job scheduler
5. Prevents duplicate listings and duplicate HubSpot deals

## Tech Stack

- **Ruby on Rails** 7.1
- **PostgreSQL** — database
- **Sidekiq** — background job processing
- **sidekiq-scheduler** — daily cron scheduling
- **HTTParty** — HTTP requests to Empire Flippers API
- **hubspot-api-client** — official HubSpot Ruby gem
- **RSpec** — test suite

## Setup

### Prerequisites
- Ruby 3.1+
- PostgreSQL
- Redis (required for Sidekiq)

### Installation
```bash
git clone https://github.com/YOUR_USERNAME/empire-sync
cd empire-sync
bundle install
```

### Environment Variables

Create a `.env` file in the root directory:
```
HUBSPOT_ACCESS_TOKEN=your_hubspot_private_app_token
```

### Database Setup
```bash
rails db:create
rails db:migrate
```

### Run Tests
```bash
bundle exec rspec
```

### Run the sync manually
```bash
rails console
ListingSyncService.sync
```

### Run Sidekiq (background jobs)
```bash
bundle exec sidekiq
```

## Architecture
```
SyncListingsJob (runs daily at midnight)
    ↓
ListingSyncService
    ├── EmpireFlippersService  →  fetches listings from EF API
    └── HubspotService         →  creates deals in HubSpot CRM
```

## HubSpot Deal Fields

| Deal Field | Source |
|---|---|
| Deal Name | `"Listing ##{listing_number}"` |
| Amount | `listing_price` |
| Close Date | 30 days from sync date |
| Description | `summary` |

## Tests

11 RSpec tests covering:
- Listing model validations
- EmpireFlippersService API fetching
- ListingSyncService sync logic and duplicate prevention
- HubspotService deal creation
- SyncListingsJob execution
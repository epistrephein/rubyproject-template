# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Template

This is a plain Ruby project template with batteries included: database (Sequel ORM), logging, Telegram notifications, AWS S3/SES, and cron scheduling. When building a new project on top of this template:

1. Run `rake template:rename PROJECT=newname` to replace all `rubyproject` references across the repo.
2. Run `bin/setup -d` (development) or `bin/setup -p` (production) to install dependencies and create config/env files from examples.
3. Customize `config/config.yml` with credentials and variables.
4. Delete `tasks/template.rake` after renaming.

## Commands

```bash
rake               # Run the main task (default)
rake spec          # Run tests
rake rubocop       # Run linter
rake test          # Run spec + rubocop
rake db:migrate    # Run database migrations
rake db:migrate[N] # Migrate to specific version
rake db:version    # Show current DB schema version
rake db:dump       # Dump database to db/dump/
rake db:backup     # Dump + upload to S3
rake web:build     # Build HTML from ERB template into web/public/index.html
rake web:serve     # Serve web/public/ locally via WEBrick
bin/console        # Interactive Ruby console with environment loaded
```

Run a single spec file:
```bash
bundle exec rspec spec/my_spec.rb
```

## Architecture

**Entry point:** `tasks/main.rake` — the `main` rake task is the primary entry point. Add project logic here or call out to classes in `lib/`.

**Auto-loading:** `lib/loader.rb` uses Zeitwerk to auto-load everything under `lib/`. Files in `lib/concerns/`, `lib/models/`, and `lib/utilities/` are collapsed (their classes/modules are available at the top level without namespace). Models are excluded from eager load; everything else is eager-loaded.

**Configuration:** `lib/config.rb` — `Config[:key, :subkey]` looks up `config/config.yml` with ENV var override support (e.g., `Config[:postgres, :host]` is overridden by `POSTGRES_HOST`).

**Database:** `lib/database.rb` — wraps Sequel. Active adapter is PostgreSQL by default; MySQL and SQLite are commented out. `Database::DB` is the raw Sequel connection. `Database` proxies unknown methods to `DB`. Migrations live in `db/migrations/` as numbered files (e.g., `001_example.rb`).

**Models:** `lib/models/` — Sequel models. Inherit from `Sequel::Model`, use `timestamps` and `validation_helpers` plugins as shown in `Example`.

**Concerns:** `lib/concerns/` — mixins. `Retryable#with_retries` retries a block with exponential backoff (`backoff**attempt`, capped at 60s) plus random jitter; `swallow_ex: true` returns instead of re-raising. Utilities `extend Retryable` and wrap every remote call in it.

**Utilities:** `lib/utilities/` — `Telegram` (notifications), `S3` (file upload), `Ses` (email). All read from `Config`.

**Logging:** `lib/log.rb` — `Log.stdout` and `Log.stderr` are Ruby `Logger` instances. Behavior controlled by `SUPPRESS_LOG`, `LOG_TO_FILE`, `STDOUT_LOG`, `STDERR_LOG` env vars.

**Tasks:** All `.rake` files under `tasks/` are auto-loaded. Each new feature or concern gets its own `.rake` file. Tasks that need the full environment use `task mytask: :environment`.

**Web output (optional):** `web/template.html.erb` + `web/variables.yml` → `rake web:build` → `web/public/index.html`.

**Cron:** `config/schedule.rb` (generated from `config/schedule.example.rb` in production) using the `whenever` gem. Update crontab with `bundle exec whenever --update-crontab`.

## Testing

`spec/` mirrors `lib/` (`spec/utilities/s3_spec.rb`, `spec/concerns/`, `spec/tasks/`). `.rspec` auto-requires `spec_helper`, which boots the full Loader — no per-file requires needed.

- SimpleCov runs on every spec; the suite is at 100% line coverage. Keep it there when adding code to `lib/`.
- Specs run in random order with `config.warnings = :all`; `.rspec_status` enables `--only-failures`.
- Utilities are tested by stubbing constants, not the network: `stub_const("S3::CLIENT", instance_double(Aws::S3::Client))` and `allow(described_class).to receive(:with_retries).and_yield`.
- Rake task specs set `ENV["SUPPRESS_LOG"] = "true"` and define a stub `:environment` task.

## Environment

- `lib/loader.rb` try-requires `dotenv/load`, rescuing `LoadError` — so `.env` is picked up in development and silently skipped in production where the gem isn't installed.
- `Config` raises at load time if any of `postgres`, `telegram`, `aws:s3`, `aws:ses` is missing from the YAML. `CONFIG_FILE` points it elsewhere.
- `DATABASE_URL` overrides the entire connection hash in `lib/database.rb`.
- CI: copy `.github/samples/main.yml` to `.github/workflows/` to activate it (same for `dependabot.yml` → `.github/`). It spins up a Postgres 17 service and runs `rake spec` + `rake rubocop`.
- README documents the full ENV override list; don't duplicate it here.

## Standards and Conventions

- Ruby 4, `frozen_string_literal: true` on every file.
- Double-quoted strings enforced by RuboCop (`Style/StringLiterals: double_quotes`), including in comments.
- Hash alignment uses table style (rocket and colon styles aligned).
- No line length limit, no metrics cops, no documentation cops.
- Errors in `main` task are caught, sent to Telegram via `Telegram.exception(e)`, logged to stderr, and exit with code 1.
- Add new gems only when strictly necessary; prefer the existing stack (Sequel for DB, aws-sdk for AWS, telegram-bot-ruby for notifications).

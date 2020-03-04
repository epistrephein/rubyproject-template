# Ruby Project

A description of the project.

## Usage

Run `bin/setup` to install all dependencies via Bundler and to duplicate the
example configuration and schedule files.
In production, run `bin/setup --without development` to skip development dependencies.

Customize `config/config.yml` with your credentials.

Optionally, to receive notifications via Telegram bot on exceptions raised, install
with `bin/setup --with notifications` and add your Telegram user id and bot
token to the `config/config.yml` file.

Use the installed `whenever` gem to schedule recurring jobs via cron.
Customize the interval in `config/schedule.rb`, then run `whenever --update-crontab`.

A development console is available using `bin/console`.

# Ruby Project

A template for plain Ruby projects with database, backups, cronjobs and telegram support.

## Usage

Customize the required gems in `Gemfile` then run `bin/setup` to install all
dependencies via Bundler and duplicate the example configuration and schedule files.
In production, pass `--without development` as argument to `bin/setup` in order
to skip development dependencies.

Run `rake template:rename PROJECT=newname` to rename the project and replace all
occurrences across the repo files.

Customize `config/config.yml` with your credentials and variables.

To disable the Telegram notification functionality or the support for remote database
backup on AWS S3, pass `--without telegram` and/or `--without aws` as argument
to `bin/setup`.

Use the installed `whenever` gem to schedule recurring jobs via cron.  
Customize the logic and the time interval in `config/schedule.rb`, then run
`whenever --update-crontab`.

A development console is available via `bin/console`.

## Environmental variables

Environmental variables have precedence over values defined in the configuration
file and can be used to override them.

#### Configuration
- `CONFIG_FILE`: Path to YAML configuration file

#### Database
###### MySQL/PostgreSQL
- `DB_HOST`: Database hostname or IP
- `DB_PORT`: Database port
- `DB_USERNAME`: Database username
- `DB_PASSWORD`: Database password
- `DB_NAME`: Database name

###### SQLite
- `DB_FILE`: Database file path

#### Logs
- `STDOUT_LOG`: Standard output log file
- `STDERR_LOG`: Standard error log file
- `DB_LOG`: Database transactions log file

#### Telegram
- `TELEGRAM_APP`: Application name used in exception message
- `TELEGRAM_TOKEN`: Bot token
- `TELEGRAM_USER`: Recipient user ID

#### AWS
- `AWS_ACCESS_KEY_ID`: Access key
- `AWS_SECRET_ACCESS_KEY`: Secret access key
- `AWS_REGION`: Region
- `AWS_BUCKET`: Bucket name
- `AWS_PREFIX`: Bucket prefix (with final slash)

# Ruby Project

A template repository for plain Ruby projects, with database and cron support.

## Usage

Customize the required gems in `Gemfile` then run `bin/setup` to install all
dependencies via Bundler and to duplicate the example configuration, schedule and
env files.  
In production, pass `--without development` as argument to `bin/setup` in order
to skip development dependencies.

Run `rake template:rename PROJECT=newname` to rename the project and replace all
occurrences across the repo files.

Customize `config/config.yml` with your credentials and variables.

To disable the Telegram notification functionality or the support for remote database
backup on AWS S3, pass `--without notifications` and/or `--without aws` as argument
to `bin/setup`.

Use the installed `whenever` gem to schedule recurring jobs via cron.  
Customize the interval in `config/schedule.rb`, then run `whenever --update-crontab`.

A development console is available using `bin/console`.

## Environmental variables

#### Configuration
- `CONFIG_FILE`: Path to YAML configuration file

#### Database
###### MySQL
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
- `APP_NAME`: Application name used in notification text
- `TELEGRAM_TOKEN`: Bot token
- `TELEGRAM_USER`: Recipient user ID

#### AWS
- `AWS_ACCESS_KEY_ID`: Access key
- `AWS_SECRET_ACCESS_KEY`: Secret access key
- `AWS_REGION`: Region
- `AWS_BUCKET`: Bucket name
- `AWS_PREFIX`: Bucket prefix (with final slash)

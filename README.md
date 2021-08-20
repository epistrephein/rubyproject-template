# Ruby Project

A template for plain Ruby projects with database, backups, cronjobs, email and telegram support.

## Usage

After cloning this template, customize the required gems in `Gemfile` then run
`bin/setup` to install all dependencies via Bundler and duplicate the example
configuration, env and schedule files.  
In production you might want to pass `--without development` as argument to
`bin/setup` in order to skip development dependencies.

Run `rake template:rename PROJECT=newname` to rename the project and replace all
occurrences across the repo files.

Customize `config/config.yml` with your credentials and variables.

Use the installed `whenever` gem to schedule recurring jobs via cron.  
Customize the logic and the time interval in `config/schedule.rb`, then run
`whenever --update-crontab`.

The development console is available via `bin/console`.

The database supports migrations out-of-the-box: add progressive migration files
in the `db/migrate` folder and run `rake db:migrate` to migrate.

To extend this template, simply add your custom code and logic in `lib/` and in 
`.rake` files under the `tasks/` directory.

## Environmental variables

Environmental variables have precedence over values defined in the configuration
file and can be used to override them.

#### Configuration
- `CONFIG_FILE`: Path to YAML configuration file

#### Database
###### MySQL/PostgreSQL
- `MYSQL_HOST` or `POSTGRES_HOST`: Database hostname or IP
- `MYSQL_PORT` or `POSTGRES_PORT`: Database port
- `MYSQL_USERNAME` or `POSTGRES_USERNAME`: Database username
- `MYSQL_PASSWORD` or `POSTGRES_PASSWORD`: Database password
- `MYSQL_DATABASE` or `POSTGRES_DATABASE`: Database name

###### SQLite
- `SQLITE_FILE`: Database file path

#### Logs
- `LOG_TO_FILE`: Log to file instead of stdout/stderr
- `STDOUT_LOG`: Standard output log file
- `STDERR_LOG`: Standard error log file

#### Telegram
- `TELEGRAM_APP_NAME`: Application name displayed in messages
- `TELEGRAM_TOKEN`: Bot token
- `TELEGRAM_USER`: Recipient user ID
- `TELEGRAM_ENABLED`: Whether Telegram notifications are enabled

#### AWS
###### S3
- `S3_ACCESS_KEY_ID`: Access key
- `S3_SECRET_ACCESS_KEY`: Secret access key
- `S3_REGION`: Region
- `S3_BUCKET`: Bucket name
- `S3_PREFIX`: Bucket prefix (with final slash)

###### SES
- `SES_ACCESS_KEY_ID`: Access key
- `SES_SECRET_ACCESS_KEY`: Secret access key
- `SES_REGION`: Region
- `SES_FROM_NAME`: Name of the sender
- `SES_FROM_EMAIL`: Email of the sender
- `SES_TO_EMAIL`: Email of the recipient(s)
- `SES_ENCODING`: Character encoding (default UTF-8)

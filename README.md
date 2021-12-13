# Ruby Project

A template for plain Ruby projects with database, backups, cronjobs, email and telegram support.

## Usage

After cloning this template, customize the required gems in `Gemfile` then run
`bin/setup -d -b [bundler version]` to install all dependencies via Bundler and
duplicate the example configuration, env and schedule files.  
In production, invoke it with `bin/setup -p` in order to configure bundler
locally for deployment and skip development dependencies.

Run `rake template:rename PROJECT=newname` to rename the project and replace all
occurrences across the repo files.

Customize `config/config.yml` with your credentials and variables.

Use the installed `whenever` gem to schedule recurring jobs via cron.  
Customize the logic and the time interval in `config/schedule.rb`, then run
`whenever --update-crontab`.

The development console is available via `bin/console`.

The database supports migrations out-of-the-box: add progressive migration files
in the `db/migrations` folder and run `rake db:migrate` to migrate.

To extend this template, simply add your custom code and logic in `lib/` and in 
`.rake` files under the `tasks/` directory.

#### HTML output

An optional rake task is available to create an HTML page from an ERB template
that can be populated with database or other dynamic values and then served by a
web server, functioning as visual output of the project.

First, customize your ERB template in `web/template.html.erb`, along with the
css and javascript in the public folder if you need to. Then setup the variables
binding in the `web/variables.yml` file. These variables will then be expanded
in the template when running `rake web:build` and a `web/public/index.html` file
will be created.  
Don't forget to call the rake task in the schedule too if you want the page to be 
updated automatically.

Use `rake web:serve` to launch WEBrick locally and see your result.

In production you'll want to serve the `web/public` folder as a whole.

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

###### Redis
- `REDIS_HOST`: Database hostname or IP
- `REDIS_PORT`: Database port
- `REDIS_DATABASE`: Database number

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
- `AWS_S3_ACCESS_KEY_ID`: Access key
- `AWS_S3_SECRET_ACCESS_KEY`: Secret access key
- `AWS_S3_REGION`: Region
- `AWS_S3_BUCKET`: Bucket name
- `AWS_S3_PREFIX`: Bucket prefix (with final slash)

###### SES
- `AWS_SES_ACCESS_KEY_ID`: Access key
- `AWS_SES_SECRET_ACCESS_KEY`: Secret access key
- `AWS_SES_REGION`: Region
- `AWS_SES_FROM_NAME`: Name of the sender
- `AWS_SES_FROM_EMAIL`: Email of the sender
- `AWS_SES_TO_EMAIL`: Email of the recipient(s)
- `AWS_SES_ENCODING`: Character encoding (default UTF-8)

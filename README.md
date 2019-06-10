# Ruby Project

A description of the project.

## Usage

Run `bin/setup` to install all dependencies via Bundler and to duplicate the
example configuration and schedule files.

Customize `config/config.yml` with your credentials.

To setup a cron script for regular checks use the installed `whenever` gem.  
Customize the interval in `config/schedule.rb`, then run `whenever --update-crontab`.

A development console is available using `bin/console`.


# README

Personal tool for sending work report email. I won't bother to write README file.

## Deployment

```shell
dokku apps:create report-mailer
dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku postgres:create report-mailer report-mailer
dokku postgres:link report-mailer report-mailer
dokku config:set report-mailer APP_HOST=report-mailer.example.com
dokku config:set report-mailer APP_EMAIL=test@example.invalid
dokku config:set report-mailer MAIL_ENABLE=true
dokku config:set report-mailer RACK_ENV=production
dokku config:set report-mailer RAILS_ENV=production
dokku config:set report-mailer RAILS_MASTER_KEY=secret
dokku config:set report-mailer BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-ruby.git

dokku certs:generate report-mailer report-mailer.example.com

git remote add dokku dokku@<host>:report-mailer
git push dokku main
```

## backup / restore

```shell
docker-compose up
docker-compose exec db pg_dump -Fc -w -h localhost -U postgres tools_development | gzip -c > dbdump.gz

gunzip dbdump.gz
gunzip -c dbdump.gz | dokku postgres:import report-mailer
```

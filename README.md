# Notepad

An educational application with which you can record reminders, links, tasks, and also tweet. Implemented in Ruby.

## Getting started

Download or clone repo

Create notepad.sqlite with filds

* type

* created_ad

* text

* url

* due_date

If you want to post tweets you need to add you api keys in lib/tweet.rb

	config.consumer_key = ''
    config.consumer_secret = ''
    config.access_token = ''
    config.access_token_secret = ''

Run notepad.rb if you want to choose the method of saving to a file or database
```
ruby notepad.rb
```

Run new_post.rb if you want to save to database
```
ruby new_post.rb
```

If you want to read records you need to run reed.rb
```
ruby read.rb
```
 
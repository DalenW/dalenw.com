# DalenW.com

My personal website.
Written and maintained by myself.

I decided to write it myself because I wanted more (and less) features than other blog platforms like Ghost or
Wordpress.
And rather than deal with making somebody else's solution work for me, I just made my own.

## Features

- [ ] Posts
    - [x] Basic posts written in Markdown
    - [x] Media support
    - [x] Image galleries
    - [ ] Number of views
    - [ ] Short links for sharing posts
    - [ ] Post tags
    - [ ] Post search
    - [ ] RSS feed
    - [ ] Image Viewer
- [ ] Recipes
- [ ] URL Shortener
- [ ] Media Manager
- [ ] Pages

## Setup

### Credentials:

`EDITOR=nano rails credentials:edit --environment development`
`EDITOR=nano rails credentials:edit --environment production`

```yml
secret_key_base:

s3:
  endpoint: s3.dalenw.net
  access_key_id: GK6fb7b6fafb726bbbe3615b83
  secret_access_key: dalenw-com-production-api-key
  bucket: dalenw-com-production
  region: garage
```

### Creating a user

`bundle exec rails c`

`User.create email_address: "email", password: "password"`
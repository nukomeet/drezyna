Drezyna
=======

Drezyna is a Rails application stack used at [Nukomeet][0].

Setup
-----

### Server

[thin][1] used for both development and production servers.

### Persistance

PostgreSQL 9.3 with ActiveRecord


### Testing:

[minitest][3] with [fabrication][4]


### Auth

Handled by [devise][5] and [pundit][6].

Remapped routes:
- `/users/sign_in` to `/login`,
- `/users/sign_out` to `/logout`
- `/users/sign_up` to `/register`

### Frontend

[slim][2] is the template language.

[foundation][8], [simple_form][9] and [compass][10]

### Email

The application is configured to send email using a Mandrill account.
Email delivery is disabled in development.


### Extras

- `rails console` runs [pry][10] by default.
- helpers generation turned off in `application.rb` with
  ```
  config.generators.helper = false
  ```

Usage
-----

### Clone this repository

```sh
git clone https://github.com/nukomeet/drezyna
```

### Adjust DB configuration:

```sh
curl -O config/database.yml https://gist.github.com/zaiste/10378957
```

Replace `NAME` and `USER_NAME` with your own values.

```
rake db:create
rake db:migrate
```

### Rename the application

```sh
mv drezyna sampleapp
cd sampleapp
bundle
rails g rename:app_to SampleApp
```

### Launch

```
rails s
```

Open `localhost:3000` and enjoy your new application.

[0]: http://nukomeet.com/
[1]: https://github.com/macournoyer/thin/
[2]: http://slim-lang.com/
[3]: https://github.com/seattlerb/minitest
[4]: http://www.fabricationgem.org/
[5]: https://github.com/plataformatec/devise
[6]: https://github.com/elabs/pundit
[8]: http://foundation.zurb.com/

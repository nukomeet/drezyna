Drezyna
=======

Drezyna is a Rails application stack used at [Nukomeet][0].

Setup
-----

### Ruby version

By default, Drezyna is running on ruby `2.1.2`.

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

[foundation][8], [simple_form][9] and [compass][11]

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

### Rename the application

```sh
mv drezyna sampleapp
cd sampleapp
bundle
rails g rename:app_to SampleApp
```

### Adjust your environment

Create a `.env` file based on `.env.sample`:

```
cp .env.sample .env
```

### Adjust DB configuration:

```sh
curl -o config/database.yml https://gist.githubusercontent.com/zaiste/10378957/raw/50dfe7f2dd2050e2903aff187fb7e11ec702fc15/database.yml
```

Edit `config/database.yml` and replace `NAME` and `USER_NAME` with your own values.

Edit `test/fixtures/users.yml` and put at least one user.

Create and fill DB:
```sh
rake db:create
rake db:migrate
rake db:fixtures:load
foreman run rake db:seed
```

### Launch

#### If you're a [Pow](http://pow.cx/) user

Set your env readable by Pow:

```sh
echo "
export PORT='5000'
export ADMIN_NAME='bonjour'
export ADMIN_EMAIL='bonjour@nukomeet.com'
export ADMIN_PASSWORD='bienvenue'
export MANDRILL_USERNAME='name@domain.com'
export MANDRILL_APIKEY='CHANGEME'
export SECRET_KEY_BASE='<run `rake secret` command and put here the result>'
" > .powenv
```

Set and access your app:

```sh
cd ~/.pow
ln -s /path/to/your/app/sampleapp .
open http://sampleapp.dev
```

#### Otherwise

```sh
foreman start
```

Access [`localhost:5000`](http://localhost:5000) and enjoy your new application.

[0]: http://nukomeet.com/
[1]: https://github.com/macournoyer/thin/
[2]: http://slim-lang.com/
[3]: https://github.com/seattlerb/minitest
[4]: http://www.fabricationgem.org/
[5]: https://github.com/plataformatec/devise
[6]: https://github.com/elabs/pundit
[8]: http://foundation.zurb.com/
[9]: https://github.com/plataformatec/simple_form
[10]: https://github.com/pry/pry
[11]: http://compass-style.org/

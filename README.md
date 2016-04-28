# RentsWatch

This app requires a system with `node` (tested with *5.7.1*), `npm` (tested with *3.5.2*) and `grunt-cli` (tested wwith *0.1.13*).

## Quick install

From the root directory

```
make install
```

## Configure

Create a configuration file using the template:

```
cp server/config/local.env.sample.js  server/config/local.env.js
```

Then change values to add the `DATABASE_URL` and the `RENTSWATCH_API_TOKEN`:

```node
module.exports = {
  DOMAIN: 'http://localhost:9000',
  SESSION_SECRET: "rentswatchapp-secret",
  DATABASE_URL: 'mysql://...',
  RENTSWATCH_API_TOKEN: '...'
};
```

## Serve files

Still from the root directory

```
make run
```

## Deploy

To deploy the app on Heroku, you must have `Docker` and `Docker Compose`
installed on your machine.

To verify that you have a working Docker installation, open a shell and run:

```
$ docker ps
CONTAINER ID        IMAGE               COMMAND ...
$ docker-compose --version
docker-compose version 1.5.2, build 7240ff3
```

You may now install the [Heroku Toolbet](https://toolbelt.heroku.com/) as follow:

```
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh
```

And the Docker plugin for the toolbelt;

```
heroku plugins:install heroku-docker
```

You may now be able to deploy the app using this command:

```
make deploy
```

## Commands

This application comes with a few commands to run in your terminal.

Command | Description
--- | ---
`make install` | ...
`make run` | ...
`make prefetch` | ...
`make deploy` | ...
`make artillery` | ...

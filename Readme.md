# Env variables

Example in - see .end.dev


# Docker

To start with --env-file ${env_file_path} parameter

```bash
docker-compose --env-file ../.env up -d

```

# Nginx

Generate nginx.config file based on template and .env file

```bash
cd $app/config
chmod +x generate-nginx-config.sh
./generate-nginx-config.sh
```

Simlink to specific conf file
```bash
ln -s $app/config/nginx.config /etc/nginx/sites-enabled/$app_name
```

# cgroups

Cgroups are there to put limit on CPU usage


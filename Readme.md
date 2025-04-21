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
just nginx-config
```

Simlink to specific conf file
```bash
ln -s $app/config/nginx.config /etc/nginx/sites-enabled/$app_name
```

# Systemd 

```bash
sudo systemctl enable wordpress-docker.service
sudo systemctl start wordpress-docker.service
```



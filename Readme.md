# What this does

From a .env file configuration, this aims to creates : 
- nginx configuation
- unix service configuration
- dockerfile parametrization

In order to host wordpress applications with secure params.
- Docker container running with limited user to limit risk of privilege escalation.
- Consistent configs made one and reproducible easily

Still a work in progress and lot of potential improvement.


## Env variables

Example in - see .end.dev

## Docker

To start with --env-file ${env_file_path} parameter

```bash
docker-compose --env-file ../.env up -d

```

## Nginx

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



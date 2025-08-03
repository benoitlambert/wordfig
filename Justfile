# Loading env variables
set dotenv-load

# Afficher les logs
logs:
    cd app && docker-compose logs -f

# Vérifier l'état des conteneurs
status:
    cd app && docker-compose ps

# Nettoyer les ressources (attention: supprime les données!)
clean:
    #!/usr/bin/env bash
    read -p "Cette action va supprimer toutes les données. Continuer? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd app && docker-compose down -v
    fi

## Generate config files based on .env 
#

# Create service config from template & env variables
service-config:
    ./adapt-env.sh config/wordpress.service.template .env config/wordpress.service

# Create nginx config from template & env variables
nginx-config:
    ./adapt-env.sh config/nginx.config.template .env config/nginx.config

# Create both nginx and service config files from templates and .env
update-config:
    just service-config
    just nginx-config

# Create simlink to /etc/nginx/sites-enabled (overrides) 
enable-nginx-site:
    #!/usr/bin/env bash
    NGINX_TARGET="/etc/nginx/sites-enabled/$SERVICE_NAME"
    echo "🔍 Checking for existing file at $NGINX_TARGET"
    if [ -e "$NGINX_TARGET" ]; then
        echo "🗑️  Removing existing file at $NGINX_TARGET"
        rm "$NGINX_TARGET"
    else
        echo "✅ No existing file found at $NGINX_TARGET"
    fi
    echo "🔗 Creating symlink from $(pwd)/config/nginx.config to $NGINX_TARGET"
    ln -s $(pwd)/config/nginx.config "$NGINX_TARGET"
    echo "✅ Nginx site successfully enabled at $NGINX_TARGET"

# Copy service file to /etc/systemd/system
enable-service:
    #!/usr/bin/env bash
    SERVICE_TARGET="/etc/systemd/system/$SERVICE_NAME.service"
    echo "🔍 Checking for existing file at $SERVICE_TARGET"
    if [ -e "$SERVICE_TARGET" ]; then
        echo "🗑️  Removing existing file at $SERVICE_TARGET"
        rm "$SERVICE_TARGET"
        echo "✅ Previous file deleted"
    else
        echo "✅ No existing file found at $SERVICE_TARGET"
    fi
    echo "🔗 Copying service file to $SERVICE_TARGET"
    cp $(pwd)/config/wordpress.service "$SERVICE_TARGET"
    echo "✅ Service successfully enabled at $SERVICE_TARGET"

service-change:
    just service-config
    just enable-service
    just activate-service

nginx-change:
    just nginx-config
    just enable-nginx-site
    systemctl reload nginx

# Daemon enable and load 
activate-service: 
    sudo systemctl start $SERVICE_NAME

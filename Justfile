# Justfile pour gérer l'application WordPress

# Lancer l'application
up:
    cd app && docker-compose --env-file ../.env up -d

# Arrêter l'application
down:
    cd app && docker-compose down

# Afficher les logs
logs:
    cd app && docker-compose logs -f

# Redémarrer l'application
restart:
    cd app && docker-compose restart

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

## NGINX
#
# Adapter le fichier de config par rapport aux variables d'environnement

nginx-config:
    cd config && ./generate-nginx-config.sh

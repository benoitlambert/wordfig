#!/bin/bash
# config/generate-nginx-config.sh

# Vérifier si le fichier .env existe
if [ ! -f ../.env ]; then
  echo "Erreur: Fichier ../.env introuvable"
  exit 1
fi

# Charger les variables d'environnement
echo "Chargement des variables depuis ../.env"
source ../.env

# Vérifier si le fichier template existe
if [ ! -f nginx.template ]; then
  echo "Erreur: Fichier template nginx.template introuvable"
  exit 1
fi

# Créer la liste des variables définies dans .env
echo "Variables disponibles pour la substitution:"
ENV_VARS=$(grep -v '^#' ../.env | grep '=' | sed 's/=.*//' | sort)

# Préparer la liste des variables à remplacer pour envsubst
VARS_TO_REPLACE=$(printf '${%s} ' $ENV_VARS)

# Remplacer les variables dans le template
echo -e "\nGénération de nginx.conf à partir du template..."
envsubst "$VARS_TO_REPLACE" < nginx.template > nginx.config

# Vérifier si la génération a réussi
if [ $? -eq 0 ]; then
  echo "Configuration Nginx générée avec succès dans nginx.conf"

  # Trouver les variables effectivement utilisées dans le template
  echo -e "\nVariables effectivement remplacées:"
  for VAR in $ENV_VARS; do
    if grep -q "\${$VAR}" nginx.template; then
      VALUE=${!VAR}
      echo "  - \${$VAR} → $VALUE"
    fi
  done
else
  echo "Erreur lors de la génération de la configuration Nginx"
  exit 1
fi


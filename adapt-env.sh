#!/usr/bin/env bash
# generic-template-generator.sh
# Script générique pour remplacer les variables d'un template avec les valeurs d'un fichier .env

# Vérifier les arguments
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <template_file> <env_file> <output_file>"
    echo "  <template_file> : Chemin vers le fichier template"
    echo "  <env_file>      : Chemin vers le fichier .env"
    echo "  <output_file>   : Chemin où générer le fichier de sortie"
    exit 1
fi

TEMPLATE_FILE="$1"
ENV_FILE="$2"
OUTPUT_FILE="$3"

# Vérifier si le fichier template existe
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Erreur: Fichier template '$TEMPLATE_FILE' introuvable"
    exit 1
fi

# Vérifier si le fichier .env existe
if [ ! -f "$ENV_FILE" ]; then
    echo "Erreur: Fichier .env '$ENV_FILE' introuvable"
    exit 1
fi

echo "🔄 Traitement du template: $TEMPLATE_FILE"
echo "📋 Utilisation du fichier .env: $ENV_FILE"

# Charger les variables d'environnement
set -a
source "$ENV_FILE"
set +a

ENV_VARS=$(grep -v '^#' "$ENV_FILE" | grep '=' | sed 's/=.*//' | sort)

# Préparer la liste des variables à remplacer pour envsubst
VARS_TO_REPLACE=$(printf '${%s} ' $ENV_VARS)

# Remplacer les variables dans le template
echo -e "🔨 Génération de $OUTPUT_FILE à partir du template..."
envsubst "$VARS_TO_REPLACE" < "$TEMPLATE_FILE" > "$OUTPUT_FILE"

# Vérifier si la génération a réussi
if [ $? -eq 0 ]; then
    echo "✅ Fichier généré avec succès dans $OUTPUT_FILE"

    # Trouver les variables effectivement utilisées dans le template
    echo -e "📊 Variables effectivement remplacées:"
    USED_VARS=0
    for VAR in $ENV_VARS; do
        if grep -q "\${$VAR}" "$TEMPLATE_FILE"; then
            VALUE=${!VAR}
            echo "  - \${$VAR} → $VALUE"
            USED_VARS=$((USED_VARS+1))
        fi
    done

    if [ $USED_VARS -eq 0 ]; then
        echo "  ⚠️ Aucune variable du fichier .env n'a été utilisée dans le template!"
    fi

    exit 0
else
    echo "❌ Erreur lors de la génération du fichier"
    exit 1
fi

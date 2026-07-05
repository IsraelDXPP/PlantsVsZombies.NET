#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-All}"
CONFIGURATION="${2:-Debug}"
NO_RESTORE="${3:-false}"
PUBLISH="${4:-false}"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

declare -A PROJECTS
PROJECTS[PCDX]="Lawn_PCDX/Lawn_PCDX.csproj"
PROJECTS[PCGL]="Lawn_PCGL/Lawn_PCGL.csproj"

build_project() {
    local name="$1"
    local project_path="$2"

    echo ""
    echo "============================================"
    echo "Building $name ($project_path)"
    echo "Configuration: $CONFIGURATION"
    echo "============================================"
    echo ""

    local restore_arg=""
    if [ "$NO_RESTORE" = "true" ]; then
        restore_arg="--no-restore"
    fi

    if [ "$PUBLISH" = "true" ]; then
        dotnet publish "$project_path" -c "$CONFIGURATION" $restore_arg
    else
        dotnet build "$project_path" -c "$CONFIGURATION" $restore_arg
    fi

    echo ""
    echo "$name built successfully!"
}

echo "PlantsVsZombies.NET Auto-Compiler"
echo "================================"

if [ "$TARGET" = "All" ]; then
    for key in "${!PROJECTS[@]}"; do
        build_project "$key" "${PROJECTS[$key]}"
    done
else
    if [[ -v PROJECTS[$TARGET] ]]; then
        build_project "$TARGET" "${PROJECTS[$TARGET]}"
    else
        echo "Error: Unknown target '$TARGET'. Valid targets: PCDX, PCGL, All"
        exit 1
    fi
fi

echo ""
echo "All builds completed successfully!"

#!/usr/bin/env bash

CONFIG="config.yaml"
LOGDIR="logs"
BATCHDIR="batches"
DATADIR="/crawls/2601_politic_yt_kanaly"        # kde v kontejneru leží tenhle konkrétní crawl
SCREENGUI_PORT=9037

# KOLEKCE NA HOSTU
COLLECTIONSDIR="/mnt/WA_2026/manuals/crawls/collections/2601_politic_yt_kanaly"
mkdir -p "$LOGDIR" "$COLLECTIONSDIR"

# Root adresář pro všechny crawly na hostu
ROOTDIR="/home/heritrix/crawls"

FILES=$(find "$BATCHDIR" -maxdepth 1 -type f -name "urls_*.txt" | sort)

for FILE in $FILES; do
    BASENAME=$(basename "$FILE")
    LOGFILE="$LOGDIR/$BASENAME.log"

    # smaž rozbité profily z předchozích běhů v konkrétní kolekci
    #rm -rf "${COLLECTIONSDIR}/profile" "${COLLECTIONSDIR}/downloads"/profile-* 2>/dev/null

    echo ""
    echo "======================================="
    echo "→ Spouštím batch: $BASENAME"
    echo "======================================="

    docker run --rm \
        -p ${SCREENGUI_PORT}:${SCREENGUI_PORT} \
        -v "${ROOTDIR}":"/crawls" \
        -v "/mnt/WA_2026/manuals/crawls/collections":"/crawls/collections" \
        -u "1101:100" \
        local-browsertrix \
        crawl \
            --profile /crawls/profiles/profile4.tar.gz \
            --screencastPort ${SCREENGUI_PORT} \
            --config "${DATADIR}/${CONFIG}" \
            --url-file "${DATADIR}/${BATCHDIR}/${BASENAME}" \
        > "$LOGFILE" 2>&1

    echo "✓ Hotovo: $BASENAME"
    echo "---------------------------------------"
done

echo ""
echo "🔥 VŠECHNY BATCHE DOKONČENY"

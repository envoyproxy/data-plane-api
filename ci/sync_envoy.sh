#!/bin/bash

set -e

API_MAIN_BRANCH="main"

if [[ -z "$ENVOY_SRC_DIR" ]]; then
    echo "ENVOY_SRC_DIR not set, it should point to a cloned Envoy repo" >&2
    exit 1
elif [[ ! -e "$ENVOY_SRC_DIR" ]]; then
    echo "ENVOY_SRC_DIR ($ENVOY_SRC_DIR) not found, did you clone it?" >&2
    exit 1
fi


# Determine last envoyproxy/envoy SHA in envoyproxy/data-plane-api
MIRROR_MSG="Mirrored from https://github.com/envoyproxy/envoy"
LAST_ENVOY_SHA="$(git log --grep="$MIRROR_MSG" -n 1 | grep "$MIRROR_MSG" \
                      | tail -n 1 \
                      | sed -e "s#.*$MIRROR_MSG @ ##")"

echo "Last mirrored envoyproxy/envoy SHA is $LAST_ENVOY_SHA"

# Compute SHA sequence to replay in envoyproxy/data-plane-api
SHAS=$(git -C "$ENVOY_SRC_DIR" rev-list --reverse "$LAST_ENVOY_SHA"..HEAD api/)

read -r -a SHAS <<< "$(git -C "$ENVOY_SRC_DIR" rev-list --reverse "$LAST_ENVOY_SHA"..HEAD api/ | tr '\n' ' ')"

# For each SHA, hard reset, rsync api/ and generate commit in
# envoyproxy/data-plane-api
API_WORKING_DIR="../envoy-api-mirror"
git -C "$ENVOY_SRC_DIR" worktree add "$API_WORKING_DIR"
for sha in "${SHAS[@]}"; do
    echo "Adding commit ${sha}"
    git -C "$API_WORKING_DIR" reset --hard "$sha"
    COMMIT_MSG="$(git -C "$API_WORKING_DIR" log --format=%B -n 1)"
    QUALIFIED_COMMIT_MSG="$(echo -e "$COMMIT_MSG\n\n$MIRROR_MSG @ $sha")"
    rsync -acv --delete --exclude "ci/" --exclude ".*" --exclude LICENSE \
          "${API_WORKING_DIR}/api/" .
    git add .
    git commit -m "$QUALIFIED_COMMIT_MSG"
done

if [[ "${#SHAS[@]}" -ne 0 ]]; then
    echo "Pushing..."
    git push origin "${API_MAIN_BRANCH}"
else
    echo "Nothing to push"
fi
echo "Done"

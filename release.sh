#!/bin/bash
set -e

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: Uncommitted changes detected. Please commit or stash changes before releasing."
  exit 1
fi

# Configure git for CI
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git config --global user.name "GitHub Actions"

# Run Maven release plugin (will handle version bump, tag, and push)
mvn -B release:prepare release:perform -DautoVersionSubmodules=true -DpushChanges=true -DreleaseVersion=auto -DdevelopmentVersion=auto

# Update Procfile to match new versioned JAR (optional, if needed)
# You may need to parse the new version from the pom.xml or tag if you want to update the Procfile
# Example (uncomment and adjust if needed):
# new_version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
# sed -i "s|demo-webapp-.*\\.jar|demo-webapp-$new_version.jar|" Procfile
# git add Procfile
# git commit -m "chore(release): update Procfile for $new_version" || true
# git push -q origin master

# GitHub release is handled by the workflow on tag push

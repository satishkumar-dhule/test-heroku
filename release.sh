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

# Build project to ensure JAR is available
mvn -B package

# Get latest tag
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
current_version=${latest_tag#v}

# Parse git log since last tag
commits=$(git log "${latest_tag}..HEAD" --pretty=%s 2>/dev/null || echo "")

# Determine version bump
bump="patch"
echo "$commits" | grep -q "^feat:" && bump="minor"
echo "$commits" | grep -q "^BREAKING CHANGE:" && bump="major"

# Calculate new version
IFS='.' read -r major minor patch <<< "$current_version"
case $bump in
    "major") major=$((major+1)); minor=0; patch=0;;
    "minor") minor=$((minor+1)); patch=0;;
    "patch") patch=$((patch+1));;
esac
new_version="$major.$minor.$patch"

# Update pom.xml
mvn -B versions:set -DnewVersion=$new_version
# Remove backup pom created by versions:set
rm -f pom.xml.versionsBackup

# Update Procfile
sed -i "s|demo-webapp-.*\\.jar|demo-webapp-$new_version.jar|" Procfile

# Commit version bump
git add pom.xml Procfile
git commit -q -m "chore(release): bump version to $new_version" || true

# Create tag
git tag -a "v$new_version" -m "Release v$new_version"

# Push changes and tags
git push -q origin master
git push -q origin "v$new_version"

# Create GitHub release
gh release create "v$new_version" \
    --title "Release v$new_version" \
    --notes "Automated release based on conventional commits" \
    --target master \
    target/demo-webapp.jar

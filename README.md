# Hello Servlet Project

A simple Java Servlet project using embedded Jetty, Maven, and GitHub Actions for CI/CD to Heroku.

## Setup

1. Run `./setup.sh` to scaffold the project.
2. Configure Heroku secrets in GitHub Actions:
   - `HEROKU_API_KEY`: Your Heroku API key
   - `HEROKU_APP_NAME`: Your Heroku app name
   - `HEROKU_EMAIL`: Your Heroku account email
3. Ensure `gh` CLI is installed and authenticated locally.

## Development

- Run locally: `mvn package && java -jar target/hello-servlet-0.1.0.jar`
- Access: `http://localhost:8080/hello`
- Test: `mvn test`

## Semantic Release

- Use conventional commits (`feat:`, `fix:`, `BREAKING CHANGE:`).
- Automatic release triggered on push/merge to `main` branch via GitHub Actions (`release.yml`).
- Manual release: Run `./release.sh` to:
  - Parse git log for conventional commits.
  - Bump version in `pom.xml` and update `Procfile`.
  - Commit, tag, and push changes.
  - Create a GitHub release with the built JAR.

## CI/CD

- CI: Runs tests on push to any branch (`ci.yml`).
- Release: Runs semantic release on push to `main` (`release.yml`).
- CD: Deploys to Heroku on GitHub release (`cd.yml`).

# Validation & Release Commands

## Local Validation

- Build and test:
  ```sh
  mvn clean verify
  ```
- Run locally:
  ```sh
  java -jar target/demo-webapp.jar
  ```
- Check current version:
  ```sh
  mvn help:evaluate -Dexpression=project.version -q -DforceStdout
  ```

## Release (Maven Release Plugin)

- Prepare release (ensure version is SNAPSHOT and working directory is clean):
  ```sh
  mvn release:prepare -DautoVersionSubmodules=true -DpushChanges=true -DreleaseVersion=<release-version> -DdevelopmentVersion=<next-snapshot-version>
  ```
- Perform release (deploys to GitHub Packages):
  ```sh
  mvn release:perform
  ```

## Troubleshooting
- Make sure you have a valid GitHub token in your environment for deploy:
  ```sh
  export GITHUB_TOKEN=your_token
  ```
- If you see `401 Unauthorized` on deploy, check your `.github/maven-settings.xml` and GitHub token permissions.

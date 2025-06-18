#!/bin/bash
set -e

# Check for required tools
command -v git >/dev/null 2>&1 || { echo "Git is required but not installed."; exit 1; }
command -v mvn >/dev/null 2>&1 || { echo "Maven is required but not installed."; exit 1; }
command -v gh >/dev/null 2>&1 || { echo "GitHub CLI (gh) is required but not installed."; exit 1; }

# Ensure directory is clean or empty
if [ -d ".git" ]; then
  echo "Directory already contains a git repository. Exiting to avoid overwriting."
  exit 1
fi

# Initialize git repository
git init -q
git checkout -q -b main

# Create directory structure
mkdir -p src/main/java/com/example \
         src/main/webapp/WEB-INF \
         .github/workflows \
         src/test/java/com/example

# Create pom.xml
cat > pom.xml << 'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>hello-servlet</artifactId>
    <version>0.1.0</version>
    <packaging>jar</packaging>
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <jetty.version>11.0.24</jetty.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-server</artifactId>
            <version>${jetty.version}</version>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-webapp</artifactId>
            <version>${jetty.version}</version>
        </dependency>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.11.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.6.0</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>com.example.Main</mainClass>
                                </transformer>
                            </transformers>
                            <createDependencyReducedPom>false</createDependencyReducedPom>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
EOF

# Create Main.java with embedded Jetty
cat > src/main/java/com/example/Main.java << 'EOF'
package com.example;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class Main {
    public static void main(String[] args) throws Exception {
        Server server = new Server(Integer.parseInt(System.getenv().getOrDefault("PORT", "8080")));
        WebAppContext context = new WebAppContext();
        context.setContextPath("/");
        context.setWar("src/main/webapp");
        server.setHandler(context);
        server.start();
        server.join();
    }
}
EOF

# Create HelloServlet.java
cat > src/main/java/com/example/HelloServlet.java << 'EOF'
package com.example;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain");
        resp.getWriter().write("Hello, World!");
    }
}
EOF

# Create web.xml
cat > src/main/webapp/WEB-INF/web.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">
</web-app>
EOF

# Create sample test
cat > src/test/java/com/example/HelloServletTest.java << 'EOF'
package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class HelloServletTest {
    @Test
    void sampleTest() {
        assertTrue(true);
    }
}
EOF

# Create Procfile for Heroku (initial version, updated by release.sh)
cat > Procfile << 'EOF'
web: java -jar target/hello-servlet-0.1.0.jar
EOF

# Create system.properties for Heroku
cat > system.properties << 'EOF'
java.runtime.version=17
EOF

# Create semantic release script
cat > release.sh << 'EOF'
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
sed -i "s|<version>.*</version>|<version>$new_version</version>|" pom.xml

# Update Procfile
sed -i "s|hello-servlet-.*\.jar|hello-servlet-$new_version.jar|" Procfile

# Commit version bump
git add pom.xml Procfile
git commit -q -m "chore(release): bump version to $new_version" || true

# Create tag
git tag -a "v$new_version" -m "Release v$new_version"

# Push changes and tags
git push -q origin main
git push -q origin "v$new_version"

# Create GitHub release
gh release create "v$new_version" \
    --title "Release v$new_version" \
    --notes "Automated release based on conventional commits" \
    --target main \
    target/hello-servlet-$new_version.jar
EOF
chmod +x release.sh

# Create CI workflow
cat > .github/workflows/ci.yml << 'EOF'
name: CI
on:
  push:
    branches:
      - '**'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Build with Maven
        run: mvn -B test
EOF

# Create CD workflow
cat > .github/workflows/cd.yml << 'EOF'
name: Deploy to Heroku
on:
  release:
    types: [published]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.event.release.target_commitish }}
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Build with Maven
        run: mvn -B package
      - name: Deploy to Heroku
        uses: akhileshns/heroku-deploy@v3.12.12
        with:
          heroku_api_key: ${{secrets.HEROKU_API_KEY}}
          heroku_app_name: ${{secrets.HEROKU_APP_NAME}}
          heroku_email: ${{secrets.HEROKU_EMAIL}}
          usedocker: false
          branch: main
EOF

# Create Release workflow
cat > .github/workflows/release.yml << 'EOF'
name: Semantic Release
on:
  push:
    branches:
      - main
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0 # Fetch all history for git log parsing
          token: ${{ secrets.GITHUB_TOKEN }}
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - name: Install GitHub CLI
        run: |
          sudo apt-get update
          sudo apt-get install -y gh
      - name: Authenticate GitHub CLI
        run: echo "${{ secrets.GITHUB_TOKEN }}" | gh auth login --with-token
      - name: Run release script
        run: ./release.sh
    permissions:
      contents: write # Allow pushing commits and tags
      packages: write # Allow creating releases
EOF

# Create README
cat > README.md << 'EOF'
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
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
target/
*.log
.idea/
*.iml
.mvn/
mvnw
mvnw.cmd
EOF

# Initial commit
git add .
git commit -q -m "chore: initial project setup"
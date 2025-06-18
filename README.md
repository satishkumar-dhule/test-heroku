# Java Web Application with Jetty Runner

This is a template Java web application that uses Maven for build management, Jetty Runner for deployment, GitHub Actions for CI/CD, and Heroku for hosting. Perfect for beginners who want to learn modern Java web development practices.

## Prerequisites

- [Java Development Kit (JDK) 17](https://adoptium.net/) installed
- [Maven](https://maven.apache.org/install.html) installed
- [Git](https://git-scm.com/downloads) installed
- [GitHub Account](https://github.com/signup)
- [Heroku Account](https://signup.heroku.com/) (for deployment)

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/test-heroku.git
   cd test-heroku
   ```

2. Build the application:
   ```bash
   mvn clean package
   ```

3. Run locally:
   ```bash
   java -jar target/dependency/jetty-runner.jar --port 8080 target/*.war
   ```

4. Open http://localhost:8080 in your browser

## Project Structure

```
├── src/                    # Source files
│   └── main/
│       ├── java/          # Java source code
│       └── webapp/        # Web resources (HTML, JSP, etc.)
├── pom.xml                # Maven configuration
├── Procfile              # Heroku deployment configuration
├── system.properties     # Java version for Heroku
└── Dockerfile           # Container configuration
```

## Understanding the Components

### Maven (pom.xml)
Maven is our build tool. The `pom.xml` file defines:
- Project dependencies
- Build plugins
- Project metadata
- GitHub Packages configuration

Key commands:
```bash
mvn clean         # Clean build artifacts
mvn package       # Build the WAR file
mvn deploy        # Publish to GitHub Packages
```

### Jetty Runner
Jetty Runner is a lightweight way to run Java web applications. Benefits:
- No need to install a full application server
- Simple to configure
- Perfect for cloud deployments

### GitHub Actions
Located in `.github/workflows/publish-package.yml`, it automates:
- Building the application
- Running tests
- Publishing to GitHub Packages
- Triggered on releases or manually

### Heroku Deployment
Files that control Heroku deployment:
- `Procfile`: Defines how to run the application
- `system.properties`: Specifies Java version
- `target/*.war`: The application to deploy
                <groupId>org.eclipse.jetty</groupId>
                <artifactId>jetty-runner</artifactId>
                <version>9.4.9.v20180320</version>
                <destFileName>jetty-runner.jar</destFileName>
              </artifactItem>
            </artifactItems>
          </configuration>
        </execution>
       </executions>
    </plugin>
  </plugins>
</build>
```

## Run your application

To build your application simply run:

```term
$ mvn package
```

And then run your app using the java command:

```term
$ java -jar target/dependency/jetty-runner.jar target/*.war
```

That's it. Your application should start up on port 8080.

## Deploy your application to Heroku

## Create a Procfile

You declare how you want your application executed in `Procfile` in the project root. Create this file with a single line:

```
web: java $JAVA_OPTS -jar target/dependency/jetty-runner.jar --port $PORT target/*.war
```

## Deploy to Heroku

Commit your changes to Git:

```term
$ git init
$ git add .
$ git commit -m "Ready to deploy"
```

Create the app:

```
$ heroku create
Creating high-lightning-129... done, stack is cedar-14
http://high-lightning-129.herokuapp.com/ | git@heroku.com:high-lightning-129.git
Git remote heroku added
```

Deploy your code:

```term
$ git push heroku master
Counting objects: 227, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (117/117), done.
Writing objects: 100% (227/227), 101.06 KiB, done.
Total 227 (delta 99), reused 220 (delta 98)

-----> Heroku receiving push
-----> Java app detected
-----> Installing Maven 3.3.3..... done
-----> Executing: mvn -B -DskipTests=true clean install
       [INFO] Scanning for projects...
       [INFO]                                                                         
       [INFO] ------------------------------------------------------------------------
       [INFO] Building petclinic 0.1.0.BUILD-SNAPSHOT
       [INFO] ------------------------------------------------------------------------
       ...
       [INFO] ------------------------------------------------------------------------
       [INFO] BUILD SUCCESS
       [INFO] ------------------------------------------------------------------------
       [INFO] Total time: 36.612s
       [INFO] Finished at: Tue Aug 30 04:03:02 UTC 2011
       [INFO] Final Memory: 19M/287M
       [INFO] ------------------------------------------------------------------------
-----> Discovering process types
       Procfile declares types -> web

-----> Compiled slug size is 62.7MB
-----> Launching... done, v5
       http://pure-window-800.herokuapp.com deployed to Heroku
```

Congratulations! Your web app should now be up and running on Heroku. Open it in your browser with:

```term
$ heroku open
```

## Development Workflow

1. Make changes to the code
2. Test locally:
   ```bash
   mvn clean package
   java -jar target/dependency/jetty-runner.jar --port 8080 target/*.war
   ```

3. Commit and push:
   ```bash
   git add .
   git commit -m "Your changes"
   git push
   ```

4. Create a release (will trigger GitHub Actions):
   - Go to GitHub → Releases → Create new release
   - Tag version (e.g., v1.0.0)
   - Publish release

## Publishing to GitHub Packages

1. Set up authentication:
   ```bash
   export GITHUB_USERNAME=your-username
   export GITHUB_TOKEN=your-personal-access-token
   ```

2. Publish:
   ```bash
   mvn clean deploy
   ```

## Deploying to Heroku

1. Install Heroku CLI:
   ```bash
   npm install -g heroku
   ```

2. Deploy:
   ```bash
   heroku create
   git push heroku main
   ```

3. Open the app:
   ```bash
   heroku open
   ```

## Docker Support

Build and run using Docker:
```bash
docker build -t myapp .
docker run -p 8080:8080 myapp
```

## Troubleshooting

1. Maven Build Issues:
   - Ensure JAVA_HOME points to JDK 17
   - Run `mvn clean` before rebuilding

2. Jetty Runner Issues:
   - Check port availability
   - Verify WAR file exists in target/

3. GitHub Actions:
   - Verify repository secrets are set
   - Check Actions tab for error logs

4. Heroku:
   - Run `heroku logs --tail` for logs
   - Verify Procfile configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Semantic Release

This project uses semantic-release for automated versioning and release management. The configuration is in `release.config.js`.

### How it works

1. Commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:
   ```bash
   feat: add new feature
   fix: fix bug
   docs: update documentation
   chore: update dependencies
   ```

2. Based on these commits, semantic-release will:
   - Determine the next version number
   - Generate release notes
   - Create a GitHub release
   - Trigger the deployment workflow

### Local Development with Semantic Release

1. Install dependencies:
   ```bash
   npm install
   ```

2. Use commitizen for formatted commits:
   ```bash
   git add .
   npx cz
   ```

## Detailed Heroku Deployment

### Initial Setup

1. Install Heroku CLI:
   ```bash
   npm install -g heroku
   ```

2. Login to Heroku:
   ```bash
   heroku login
   ```

3. Create Heroku app:
   ```bash
   heroku create your-app-name
   ```

### Configuration

1. Set Java version in `system.properties`:
   ```properties
   java.runtime.version=17
   ```

2. Configure Heroku buildpacks:
   ```bash
   heroku buildpacks:set heroku/java
   ```

3. Set environment variables:
   ```bash
   heroku config:set JAVA_OPTS="-XX:+UseContainerSupport"
   heroku config:set MAVEN_CUSTOM_OPTS="-DskipTests"
   ```

### Advanced Heroku Features

1. Configure Heroku add-ons:
   ```bash
   heroku addons:create heroku-postgresql:hobby-dev
   heroku addons:create papertrail:choklad
   ```

2. Scale dynos:
   ```bash
   heroku ps:scale web=1
   ```

3. View logs:
   ```bash
   heroku logs --tail
   ```

### Automated Deployments

1. Enable GitHub integration:
   - Go to Heroku Dashboard → Deploy
   - Connect to GitHub
   - Enable automatic deploys from main branch

2. Manual deployment:
   ```bash
   git push heroku main
   ```

## GitHub Actions Workflows

### 1. Package Publishing (`publish-package.yml`)
Handles Maven package publishing to GitHub Packages:
```yaml
name: Publish Package
on:
  release:
    types: [published, released]
  workflow_dispatch:

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      - run: mvn deploy
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 2. Semantic Release (`semantic-release.yml`)
Handles versioning and release creation:
```yaml
name: Semantic Release
on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm install
      - run: npx semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### 3. Heroku Deployment (`deploy.yml`)
Handles deployment to Heroku:
```yaml
name: Deploy to Heroku
on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: akhileshns/heroku-deploy@v3.12.14
        with:
          heroku_api_key: ${{ secrets.HEROKU_API_KEY }}
          heroku_app_name: ${{ secrets.HEROKU_APP_NAME }}
          heroku_email: ${{ secrets.HEROKU_EMAIL }}
```

## Advanced Configuration

### Customizing Jetty Runner

1. Memory configuration:
   ```bash
   java -Xmx512m -jar jetty-runner.jar your-app.war
   ```

2. Session handling:
   ```bash
   java -jar jetty-runner.jar --session-timeout 30 your-app.war
   ```

3. SSL configuration:
   ```bash
   java -jar jetty-runner.jar --ssl --keystore keystore.jks your-app.war
   ```

### Maven Profiles

The project includes different Maven profiles:
```bash
# Development profile
mvn clean package -Pdev

# Production profile
mvn clean package -Pprod

# Heroku profile
mvn clean package -Pheroku
```

## Testing

### Running Tests Locally

1. Run all tests:
   ```bash
   mvn test
   ```

2. Run a specific test:
   ```bash
   mvn test -Dtest=HelloServiceTest
   ```

3. Run with coverage report:
   ```bash
   mvn verify
   ```
   Coverage report will be available in `target/site/jacoco/index.html`

### Test Structure

- Unit Tests: `src/test/java/com/example/demo/`
  - `HelloServiceTest.java`: Tests the service layer
  - `HelloServletTest.java`: Tests the servlet endpoints

### Continuous Integration

The project includes automated testing in the CI pipeline:

1. On every push and pull request:
   - Builds the project
   - Runs all tests
   - Generates test reports
   - Performs SonarCloud analysis

2. View test results:
   - GitHub Actions → CI workflow → Test Results
   - SonarCloud dashboard for code quality metrics

### Adding New Tests

1. Create test class in `src/test/java/`:
   ```java
   public class YourClassTest {
       @Test
       public void testYourMethod() {
           // Arrange
           YourClass instance = new YourClass();
           
           // Act
           String result = instance.yourMethod();
           
           // Assert
           assertNotNull(result);
       }
   }
   ```

2. Running during development:
   ```bash
   mvn test -Dtest=YourClassTest
   ```

### Test Coverage Requirements

- Minimum coverage: 80%
- All new code must include tests
- Pull requests require passing tests

### Mocking Dependencies

The project uses Mockito for mocking:
```java
@Test
public void testWithMocks() {
    // Create mock
    Dependency mock = mock(Dependency.class);
    when(mock.someMethod()).thenReturn("result");
    
    // Use mock
    YourClass instance = new YourClass(mock);
    String result = instance.methodUsingDependency();
    
    // Verify
    verify(mock).someMethod();
    assertEquals("expected", result);
}
```

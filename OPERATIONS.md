# Pricewell — Rocky Linux Operations Guide

Sales automation and pricing platform for professional services organizations.
Framework: Grails 7.0.9 / Spring Boot 3.5.x (Groovy/JVM). Deployment target: executable JAR or WAR on Tomcat 10.

---

## 1. System Requirements

| Component | Version | Notes |
|-----------|---------|-------|
| OS | Rocky Linux 8.x or 9.x | |
| Java | JDK 17 (LTS) | Required by Spring Boot 3.x and Grails 7 |
| MySQL | 8.0+ | Schema created by Hibernate on first boot if empty |
| Grails | 7.0.9 | Included via Gradle wrapper — no separate install required |
| Gradle | 8.x | Bundled as `gradlew` / `gradlew.bat` in the repo root |
| Tomcat | 10.x | Required for Jakarta EE 10 (Servlet 5.0); Tomcat 9.x and earlier are incompatible |
| RAM | 1 GB minimum | 2 GB recommended; set `-Xmx1024m` |

> **Breaking change from Grails 2:** `javax.*` packages have been replaced by `jakarta.*` throughout.
> Tomcat 10+ is required; Tomcat 8/9 will not load the WAR.

---

## 2. Install Prerequisites

```bash
# Java 17
sudo dnf install -y java-17-openjdk java-17-openjdk-devel

# Verify
java -version   # must print openjdk version "17..."

# MySQL
sudo dnf install -y mysql-server
sudo systemctl enable --now mysqld

# Tomcat 10 (adjust download URL to latest 10.x)
sudo dnf install -y tomcat   # or install manually from https://tomcat.apache.org/
sudo systemctl enable tomcat
```

Set `JAVA_HOME` for Tomcat:

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk' \
     | sudo tee /etc/profile.d/jdk17.sh
source /etc/profile.d/jdk17.sh
```

Grails itself does **not** need to be installed separately. The Gradle wrapper (`./gradlew`) in the repo root downloads all required build tooling on first use.

---

## 3. Database Setup

### Create the schema

The application uses `dbCreate: update` (Hibernate `hbm2ddl.auto: update`) for development and production, meaning Hibernate will auto-create or migrate missing tables on startup. No manual SQL import is required for a fresh install.

```bash
# Create the database and user
mysql -u root -p <<'SQL'
CREATE DATABASE IF NOT EXISTS pricewell CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'usr'@'localhost' IDENTIFIED BY 'sa';
GRANT ALL PRIVILEGES ON pricewell.* TO 'usr'@'localhost';
FLUSH PRIVILEGES;
SQL
```

To import an existing data dump:
```bash
mysql -u root -p pricewell < backup.sql
```

### Production database credentials

Production credentials are configured in `pricewell/grails-app/conf/application.yml` under the `production` environment block, with host and database name overrideable via JVM system properties:

| Property | Default | System property override |
|----------|---------|--------------------------|
| Host | `localhost` | `-DdbHostName=<hostname>` |
| Database | `pricewell` | `-DdbName=<database>` |
| Username | `usr` | hardcoded in `application.yml` — change before building |
| Password | `sa` | hardcoded in `application.yml` — change before building |

Edit `pricewell/grails-app/conf/application.yml` → `environments.production.dataSource` before building for production.

---

## 4. File System Layout

Create the following directories before starting the application:

```bash
sudo mkdir -p /var/pricewell/uploadedFiles/{territories,accounts,documents}
sudo mkdir -p /var/pricewell/sow-files
sudo mkdir -p /var/log/pricewell

sudo chown -R tomcat:tomcat /var/pricewell /var/log/pricewell
sudo chmod -R 755 /var/pricewell /var/log/pricewell
```

| Path | Purpose |
|------|---------|
| `/var/pricewell/uploadedFiles/` | Account logos, territory images, uploaded documents |
| `/var/pricewell/sow-files/` | SOW template `.docx` files |
| `/var/log/pricewell/` | Application log |

---

## 5. Build

The build system is Gradle 8.x using the Gradle wrapper. No separate Grails installation is needed.

```bash
# From the repo root

# Clean previous build artefacts
./gradlew clean

# Compile only (fast check)
./gradlew :pricewell:compileGroovy

# Run all tests (H2 in-memory, no MySQL required)
./gradlew :pricewell:test

# Build a deployable WAR
./gradlew :pricewell:assemble
# Output: pricewell/build/libs/pricewell-0.1.war
```

### Subproject structure

The build is a multi-project Gradle build. `settings.gradle` at the repo root includes:

```
pricewell              — main web application
pricewellDomain        — domain classes (User, Role, Staging, etc.)
connectwiseIntegration — ConnectWise CRM adapter
salesforceIntegration  — Salesforce CRM adapter
calendar               — calendar utilities
```

All subproject JARs are included in the WAR via `implementation project(':...')` dependencies in `pricewell/build.gradle`. All subprojects must be present when building.

---

## 6. Deploy to Tomcat

```bash
# Copy WAR to Tomcat webapps
sudo cp pricewell/build/libs/pricewell-0.1.war /var/lib/tomcat/webapps/pricewell.war

# Configure JVM options
sudo tee /usr/share/tomcat/bin/setenv.sh > /dev/null <<'EOF'
export CATALINA_OPTS="
  -server
  -Xms512m
  -Xmx1024m
  -DdbHostName=localhost
  -DdbName=pricewell
  -Dgrails.env=production
"
EOF
sudo chmod +x /usr/share/tomcat/bin/setenv.sh

# Start Tomcat
sudo systemctl restart tomcat

# Tail startup log
sudo journalctl -u tomcat -f
```

> **Note:** `-XX:MaxPermSize` is no longer valid on JDK 17 (PermGen was removed in Java 8). Remove it from any existing `setenv.sh` files.

The application starts on **port 8080** by default. Access via:
```
http://<server-ip>:8080/pricewell/
```

### Firewall

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Run as executable JAR (alternative to WAR)

```bash
./gradlew :pricewell:bootRun -Dgrails.env=production
```

---

## 7. Configuration Files

All configuration lives in `pricewell/grails-app/conf/application.yml`.
Changes require a rebuild and redeployment (or `bootRun` restart in development).

> **Migration note:** The Grails 2 files `Config.groovy`, `DataSource.groovy`, and
> `WebXmlConfig.groovy` have been replaced by `application.yml`.

### Database (`dataSource` block)

Controls database connections per environment (development / test / production).
Key Hibernate settings:

```yaml
hibernate:
    cache:
        use_second_level_cache: false
        use_query_cache: false
    hbm2ddl:
        auto: update
```

Connection pool keepalive (under `dataSource.properties`):
- Idle connections evicted after **30 minutes**
- Validation query: `SELECT 1` (runs on borrow, while idle, and on return)

### Server URL

Set `grails.serverURL` for production link generation (emails, absolute redirects):

```yaml
environments:
    production:
        grails:
            serverURL: 'https://pricewell.example.com/pricewell'
```

### Session timeout

```yaml
server:
    servlet:
        session:
            timeout: 480m
```

### Spring Security (`grails.plugin.springsecurity` block)

URL access rules are defined in `interceptUrlMap` inside `application.yml`.
All unlisted URLs require an authenticated session (`isAuthenticated()`).

- Login form URL: `/auth/login`
- Login processing URL: `/login/authenticate` (POST — changed from `/j_spring_security_check` in Grails 2)
- Login form field names: `username` and `password` (changed from `j_username`/`j_password`)
- Remember-me field name: `remember-me`
- Passwords: BCrypt (`password.algorithm: 'bcrypt'`)

### Logging (`logback.xml`)

Logging is configured in `pricewell/grails-app/conf/logback.xml` (replaces Grails 2 `log4j` block in `Config.groovy`).

To write logs to an absolute path, edit `logback.xml`:
```xml
<appender name="FILE" class="ch.qos.logback.core.FileAppender">
    <file>/var/log/pricewell/pricewell.log</file>
    ...
</appender>
```

For log rotation configure `logrotate`:

```bash
sudo tee /etc/logrotate.d/pricewell > /dev/null <<'EOF'
/var/log/pricewell/pricewell.log {
    daily
    rotate 14
    compress
    missingok
    notifempty
    copytruncate
}
EOF
```

### Email (`SendMailService` / `grails.mail.*`)

SMTP configuration belongs in `application.yml` under `grails.mail`:

```yaml
grails:
    mail:
        host: your.smtp.host
        port: 587
        username: your-smtp-user
        password: your-smtp-password
        default:
            from: notifications@your-domain.com
```

---

## 8. Application Bootstrap

On every startup, `BootStrap.groovy` automatically (all operations are idempotent):

1. **Initialises roles** — creates `ROLE_SYSTEM_ADMINISTRATOR`, `ROLE_PORTFOLIO_MANAGER`,
   `ROLE_PRODUCT_MANAGER`, `ROLE_SERVICE_DESIGNER`, `ROLE_SALES_PERSON`, `ROLE_SALES_MANAGER`,
   `ROLE_GENERAL_MANAGER`, `ROLE_SALES_PRESIDENT`, `ROLE_DELIVERY_ROLE_MANAGER`
2. **Creates default users** — `admin`, `superadmin`, `nobody` with BCrypt-hashed passwords
3. **Populates workflow stages** — Service, Quotation, Opportunity, Lead, and Service Quotation stages
4. **Adds default settings** — deliverable types, activity types, SOW milestone types
5. **Runs data-migration fixups** — safe to run repeatedly on an existing database
6. **Starts background timers** — `SendMailTimer`, `OpportunityExpireTimer`,
   `OpportunityImportTimer`, `SalesforceOpportunityImportTimer`

Bootstrap runs synchronously during startup. On a large existing database it may take
10–30 seconds before the application accepts requests.

> **Grails 7 implementation note:** The `init` closure in `BootStrap.groovy` does not
> receive an implicit transaction in Grails 7. All GORM operations are wrapped in
> `Role.withTransaction {}`. If you add new GORM calls to `BootStrap.groovy`, place them
> inside this block.

---

## 9. First-Time Setup (After First Boot)

Navigate to the login page:

```
http://<host>:8080/pricewell/auth/login
```

```
Username: admin
Password: admiN123!
```

Then follow the setup wizard (`/setup`):

1. **Access Control** — review the 9 default roles; create users and assign roles
2. **Delivery Roles** — define the billable roles used in pricing (e.g. "Senior Consultant")
3. **Geographies (GEOs)** — define territories; users are scoped to GEOs for data visibility
4. **GEO Groups** — group GEOs for General Manager visibility scope
5. **Rate Cards** — set daily/hourly rates per Delivery Role × GEO (`RelationDeliveryGeo`)
6. **Portfolio & Services** — create a Portfolio, then define Services within it
7. **CRM Integration** (optional) — configure ConnectWise or Salesforce credentials
   via *Administration → ConnectWise Credentials*

---

## 10. Background Jobs

The following timer-based jobs start automatically at bootstrap:

| Job | Purpose | Notes |
|-----|---------|-------|
| `SendMailTimer` | Batches and sends queued email notifications | Uses `grails.mail` SMTP config |
| `OpportunityExpireTimer` | Marks opportunities as expired past their close date | |
| `OpportunityImportTimer` | Periodically pulls opportunities from ConnectWise | Requires ConnectWise credentials |
| `SalesforceOpportunityImportTimer` | Periodically pulls opportunities from Salesforce | Requires Salesforce credentials |

CRM import timers only start if the corresponding integration class is on the classpath (checked via `salesCatalogService.isClass()`). No additional configuration is needed to disable them when credentials are not configured.

---

## 11. Running Tests

Tests use an H2 in-memory database and do not require MySQL.

```bash
# All tests
./gradlew :pricewell:test

# A single test class
./gradlew :pricewell:test --tests "com.valent.pricewell.SomeServiceSpec"

# With verbose output
./gradlew :pricewell:test --info

# HTML report
open pricewell/build/reports/tests/test/index.html
```

### H2 compatibility notes

The test H2 URL includes `NON_KEYWORDS=VALUE` to prevent H2 2.x from treating the SQL
keyword `VALUE` as reserved (used as a column name in `InternalMap`):

```yaml
# application.yml — test environment
dataSource:
    url: 'jdbc:h2:mem:testDb;LOCK_TIMEOUT=10000;DB_CLOSE_DELAY=-1;NON_KEYWORDS=VALUE'
```

If H2 reports a syntax error on a column name, add the offending keyword to `NON_KEYWORDS`.

---

## 12. Grails Environment Selection

```bash
# Run in development mode (MySQL on localhost, dbCreate=update)
./gradlew :pricewell:bootRun

# Run in test mode (H2 in-memory, dbCreate=create-drop)
./gradlew :pricewell:bootRun -Dgrails.env=test

# Run in production mode
./gradlew :pricewell:bootRun -Dgrails.env=production -DdbHostName=myhost -DdbName=pricewell

# Build a production WAR (environment baked in at build time)
./gradlew :pricewell:assemble -Dgrails.env=production
```

---

## 13. Security Notes

- Default admin password (`admiN123!`) **must be changed** immediately after first login.
- Production database credentials in `application.yml` (`usr`/`sa`) are default placeholders.
  Change both the username and password, and restrict MySQL grants to `localhost` only.
- Spring Security URL rules are in the `interceptUrlMap` block in `application.yml`.
  All unlisted URLs require `isAuthenticated()`.
- Authentication is handled by **Spring Security Core 7.0.1**. The login processing
  endpoint is `/login/authenticate` (POST).
- Passwords are hashed with **BCrypt**. New users created through the UI or
  `UserManagementService` automatically receive BCrypt hashes.
- **Existing database users** migrated from a SHA-256 password store will have their
  passwords rejected on first login. Reset passwords via the admin UI (`/userAdmin`).
- The `console/` plugin (if enabled) provides a live Groovy REPL and grants arbitrary
  code execution. Ensure it is excluded from production builds or blocked at the firewall.

---

## 14. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `ClassNotFoundException: com.mysql.jdbc.Driver` | Wrong JDBC driver class | Verify `driverClassName: 'com.mysql.cj.jdbc.Driver'` in `application.yml` (the old `com.mysql.jdbc.Driver` was removed in Connector/J 8) |
| `Communications link failure` on startup | MySQL not running or wrong host | Check `systemctl status mysqld`; verify `-DdbHostName` |
| Bootstrap runs but app shows 404 | WAR deployed to wrong context path | Access via `/pricewell/` not `/` |
| `NoSuchMethodError` or `IncompatibleClassChangeError` on startup | Tomcat 9 or earlier | Upgrade to Tomcat 10.x (required for Jakarta EE 10) |
| `The specified user domain class '...' is not a domain class` | `pricewellDomain` JAR not scanned | Verify `Application.groovy` overrides `limitScanningToApplication()` to return `false` |
| `TransactionRequiredException` in BootStrap | GORM `.save()` outside transaction | Ensure the call is inside the `Role.withTransaction {}` block in `BootStrap.groovy` |
| `ClassCastException: String cannot be cast to Enum` in HQL | String literal passed where enum expected | Use `StagingType.valueOf(str)` or pass the enum constant directly |
| SOW generation fails with `FileNotFoundException` | `SOWFiles/` path not found | Verify Tomcat working directory or use an absolute path in `GenerateSOWService` |
| Uploads fail silently | `uploadedFiles/` not writable | `chown tomcat:tomcat /var/pricewell/uploadedFiles` |
| Emails not sent | SMTP config wrong | Check `grails.mail` block in `application.yml` |
| Login page shows 404 | Auth URL mapping missing | Verify `/auth/login` mapping in `UrlMappings.groovy`; access via `/pricewell/auth/login` |
| Login always redirects to `?login_error=1` | Wrong field names in form POST | Form must POST `username` and `password` to `/login/authenticate` |
| Existing user can't log in after migration | SHA-256 password hash incompatible with BCrypt | Reset password via admin UI at `/userAdmin` |
| Session expires immediately | Session timeout misconfigured | Check `server.servlet.session.timeout` in `application.yml` — default is `480m` |
| H2 syntax error on `VALUE` column | `VALUE` is reserved in H2 2.x | Add `NON_KEYWORDS=VALUE` to the H2 JDBC URL in the test environment |
| `NullPointerException` in `Staging.findAll` | String stage category not converted to enum | Call `StagingType.valueOf(stageCategory)` before passing as HQL parameter |

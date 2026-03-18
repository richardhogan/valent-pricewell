# Pricewell — Rocky Linux Operations Guide

Sales automation and pricing platform for professional services organizations.
Framework: Grails 2.0.0 (Groovy/JVM). Deployment target: WAR on Tomcat.

---

## 1. System Requirements

| Component | Minimum | Notes |
|-----------|---------|-------|
| OS | Rocky Linux 8.x or 9.x | |
| Java | JDK 8 | Source compiled at level 1.6; JDK 8 is the recommended runtime on modern Linux |
| MySQL | 5.7+ | Schema dump was created with MySQL 5.0.77; 5.7/8.0 are compatible |
| Grails | 2.0.0 | Must match `app.grails.version` in `application.properties` |
| Tomcat | 7.x or 8.x | Grails 2.x Tomcat plugin targets Servlet API 2.4/3.0 |
| RAM | 1 GB minimum | 2 GB recommended; set `-Xmx1024m` |

---

## 2. Install Prerequisites

```bash
# Java 8
sudo dnf install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Verify
java -version

# MySQL
sudo dnf install -y mysql-server
sudo systemctl enable --now mysqld

# Tomcat 8 (adjust version as needed)
sudo dnf install -y tomcat
sudo systemctl enable tomcat
```

Install Grails 2.0.0. Rocky Linux does not ship Grails via dnf; install manually:

```bash
curl -L https://github.com/grails/grails-core/releases/download/v2.0.0/grails-2.0.0.zip \
     -o /tmp/grails-2.0.0.zip
sudo unzip /tmp/grails-2.0.0.zip -d /opt/
sudo ln -s /opt/grails-2.0.0 /opt/grails

# Add to /etc/profile.d/grails.sh
echo 'export GRAILS_HOME=/opt/grails' | sudo tee /etc/profile.d/grails.sh
echo 'export PATH=$GRAILS_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/grails.sh
source /etc/profile.d/grails.sh

grails --version   # should print: Grails version: 2.0.0
```

Set `JAVA_HOME` explicitly (Grails requires it):

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk' \
     | sudo tee -a /etc/profile.d/grails.sh
source /etc/profile.d/grails.sh
```

---

## 3. Database Setup

### Create the schema

The repo includes a full MySQL dump. Import it to create all tables and reference data:

```bash
# Create the database and user
mysql -u root -p <<'SQL'
CREATE DATABASE IF NOT EXISTS pricewell CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS 'usr'@'localhost' IDENTIFIED BY 'sa';
GRANT ALL PRIVILEGES ON pricewell.* TO 'usr'@'localhost';
FLUSH PRIVILEGES;
SQL

# Import schema and sample data
mysql -u root -p pricewell < pricewell/grails-app/all.sql
mysql -u root -p pricewell < pricewell/grails-app/justData.sql
```

> **Note:** `DataSource.groovy` sets `dbCreate = "update"` for all environments.
> On first run Hibernate will auto-create or migrate any missing tables/columns.
> The SQL import is optional if you prefer to let Hibernate build the schema from scratch.

### Production database credentials

Production credentials are read from JVM system properties at startup (see Section 6).
The defaults baked into `DataSource.groovy` are:

| Property | Default | System property override |
|----------|---------|--------------------------|
| Host | `localhost` | `-DdbHostName=<hostname>` |
| Database | `pricewell` | `-DdbName=<database>` |
| Username | `usr` | hardcoded — edit `DataSource.groovy` to change |
| Password | `sa` | hardcoded — edit `DataSource.groovy` to change |

Change the hardcoded credentials in `pricewell/grails-app/conf/DataSource.groovy` before building for production.

---

## 4. File System Layout

Create the following directories before starting the application. The app resolves paths relative to the servlet context root, so these must exist and be writable by the Tomcat user.

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
| `/var/pricewell/sow-files/` | SOW template `.docx` files (replaces the old `G:/SOWFiles/`) |
| `/var/log/pricewell/` | Application log (`mylog.log`) |

The `SOWFiles/` relative path in `GenerateSOWService.groovy` has already been updated in this repo.
For production, if you deploy as a WAR to an external Tomcat, the working directory may differ —
set `CATALINA_HOME` and verify that `SOWFiles/` is reachable from Tomcat's working directory,
or update `GenerateSOWService` to use the absolute path `/var/pricewell/sow-files/`.

---

## 5. Build

There is no `Makefile` in the repository. The Jenkinsfile references `make`, `make check`,
and `make publish`, but these targets must be created by your CI/ops team. Use the
equivalent Grails commands directly:

```bash
cd pricewell/

# Clean previous build artefacts
grails clean

# Run all tests (outputs JUnit XML to target/test-reports/)
grails test-app

# Build a deployable WAR
grails war
# Output: pricewell/target/pricewell-0.1.war
```

The WAR filename comes from `application.properties`:
```
app.name=pricewell
app.version=0.1
```

### Local plugin references

`BuildConfig.groovy` declares the sibling directories as inline plugins:

```groovy
grails.plugin.location.'pricewell-domain'        = "../pricewellDomain"
grails.plugin.location.'connectwiseIntegration'  = "../connectwiseIntegration"
// ...
```

All plugin directories must be present at build time. Do not move or rename sibling directories.

> **Note:** The `nimble` local plugin has been removed. Authentication is now handled by
> the `spring-security-core:1.2.7.3` plugin declared in `BuildConfig.groovy` via Maven Central.

---

## 6. Deploy to Tomcat

```bash
# Copy WAR to Tomcat webapps
sudo cp pricewell/target/pricewell-0.1.war /var/lib/tomcat/webapps/pricewell.war

# Configure JVM options — create or edit /etc/tomcat/conf.d/pricewell.conf (or setenv.sh)
sudo tee /usr/share/tomcat/bin/setenv.sh > /dev/null <<'EOF'
export CATALINA_OPTS="
  -server
  -Xms512m
  -Xmx1024m
  -XX:MaxPermSize=256m
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
# Or: sudo tail -f /var/log/tomcat/catalina.out
```

The application starts on **port 8080** by default. Access via:
```
http://<server-ip>:8080/pricewell/
```

### Firewall

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

---

## 7. Configuration Files

All configuration lives under `pricewell/grails-app/conf/`. Changes require a rebuild and redeployment.

### `DataSource.groovy`
Controls database connections per environment (development / test / production).
See Section 3 for values. Key Hibernate settings:

```groovy
hibernate {
    cache.use_second_level_cache = true   // EHCache second-level cache enabled
    cache.use_query_cache        = true
}
```

Connection pool keepalive:
- Idle connections evicted after **30 minutes**
- Validation query: `SELECT 1` (runs on borrow, while idle, and on return)

### `Config.groovy`
- `grails.serverURL` — **must be set** for production link generation (emails, redirects).
  Currently blank; set it to your public URL, e.g. `https://pricewell.example.com/pricewell`.
- Log file: `file name:'file', file:'mylog.log'` — relative to Tomcat working directory.
  Change to an absolute path for reliability:
  ```groovy
  file name:'file', file:'/var/log/pricewell/mylog.log'
  ```
- Spring Security block (`grails.plugins.springsecurity.*`) — controls login URL (`/auth/login`),
  password encoding (BCrypt), and the `interceptUrlMap` URL access rules. Edit this block to
  add or restrict URL-level access control. Do not remove the `IS_AUTHENTICATED_REMEMBERED`
  catch-all at the bottom of the map.

### `WebXmlConfig.groovy`
Session timeout is set to **480 minutes** (8 hours). Adjust as needed:
```groovy
webxml { sessionConfig.sessionTimeout = 480 }
```

> **Removed:** `NimbleConfig.groovy` is no longer used. The SMTP block it contained for email
> notifications has been superseded by `web-app/props/email.properties` (used by `SendMailService`).

### `web-app/props/email.properties`
A second SMTP configuration used by `SendMailService`. Update before deployment:
```properties
mail.smtp.host=your.smtp.host
mail.smtp.port=587
mail.smtp.auth=true
username=your-smtp-user
password=your-smtp-password
from=notifications@your-domain.com
```

---

## 8. Application Bootstrap

On every startup, `BootStrap.groovy` automatically:

1. Initialises roles (idempotent — skipped if the bootstrap revision is already recorded):
   `ROLE_SYSTEM_ADMINISTRATOR`, `ROLE_PORTFOLIO_MANAGER`, `ROLE_PRODUCT_MANAGER`,
   `ROLE_SERVICE_DESIGNER`, `ROLE_SALES_PERSON`, `ROLE_SALES_MANAGER`, `ROLE_GENERAL_MANAGER`,
   `ROLE_SALES_PRESIDENT`, `ROLE_DELIVERY_ROLE_MANAGER`
2. Creates default users (`admin`, `superadmin`, `nobody`) if they do not exist, with BCrypt-hashed
   passwords, via `UserManagementService`
3. Populates workflow stages for Services, Quotations, Opportunities, Leads, and Service Quotations
4. Adds default settings, deliverable types, activity types, SOW milestone types
5. Runs a series of data-migration fixups (idempotent — safe to run repeatedly)
6. Starts background timer jobs: `SendMailTimer`, `OpportunityExpireTimer`,
   `OpportunityImportTimer`, `SalesforceOpportunityImportTimer`

Bootstrap runs synchronously during Tomcat startup. On a large existing database it may take
10–30 seconds before the application accepts requests.

---

## 9. First-Time Setup (After First Boot)

Navigate to the login page and sign in with the default administrator account:

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

The following Quartz jobs start automatically at bootstrap:

| Job | Purpose | Notes |
|-----|---------|-------|
| `SendMailTimer` | Batches and sends queued email notifications | Uses `email.properties` SMTP |
| `OpportunityExpireTimer` | Marks opportunities as expired past their close date | |
| `OpportunityImportTimer` | Periodically pulls opportunities from ConnectWise | Requires ConnectWise credentials |
| `SalesforceOpportunityImportTimer` | Periodically pulls opportunities from Salesforce | Requires Salesforce credentials |

To disable CRM import timers when credentials are not configured, the timers check for the
presence of valid credentials before running — no additional configuration is needed.

---

## 11. Logging

Log4j is configured in `Config.groovy`. Default appenders:

| Appender | Destination |
|----------|-------------|
| `stdout` | Console / `catalina.out` |
| `file` | `mylog.log` (relative to working dir) |

Root level: **INFO**. Framework packages (Spring, Hibernate, Grails internals) log at **ERROR**.

To redirect the file log to an absolute path, edit `Config.groovy`:
```groovy
log4j = {
    appenders {
        file name:'file', file:'/var/log/pricewell/mylog.log'
    }
    ...
}
```

Rebuild and redeploy after the change. For log rotation, configure `logrotate`:

```bash
sudo tee /etc/logrotate.d/pricewell > /dev/null <<'EOF'
/var/log/pricewell/mylog.log {
    daily
    rotate 14
    compress
    missingok
    notifempty
    copytruncate
}
EOF
```

---

## 12. Monitoring (Optional)

The `Config.groovy` includes a commented-out JavaMelody block. To enable application
performance monitoring, uncomment and rebuild:

```groovy
// In Config.groovy:
javamelody.disabled = false
javamelody.'system-actions-enabled' = true
javamelody.'displayed-counters' = 'http,sql,error,log,spring,jsp'
javamelody.'url-exclude-pattern' = '/static/.*'
```

Once enabled, the monitoring dashboard is available at:
```
http://<host>:8080/pricewell/monitoring
```
Access is restricted to users with the SYSTEM ADMINISTRATOR role.

---

## 13. Running Tests

Tests use an H2 in-memory database and do not require MySQL.

```bash
cd pricewell/

# All tests
grails test-app

# A single test class
grails test-app com.valent.pricewell.SomeServiceTests

# A single test method
grails test-app com.valent.pricewell.SomeServiceTests.testSomething

# Output
# JUnit XML: pricewell/target/test-reports/
# HTML report: pricewell/target/test-reports/html/
```

---

## 14. Grails Environment Selection

Grails supports `development`, `test`, and `production` environments.
The environment determines which `DataSource.groovy` block is active.

```bash
# Run in development mode (MySQL on localhost, dbCreate=update)
grails run-app

# Run in production mode (reads -DdbHostName / -DdbName)
grails -Dgrails.env=production run-app

# Build a production WAR
grails war   # defaults to production environment
```

When deploying the WAR to Tomcat, pass `-Dgrails.env=production` via `CATALINA_OPTS`
(already included in the `setenv.sh` example in Section 6).

---

## 15. Security Notes

- Default admin password (`admiN123!`) **must be changed** immediately after first login.
- SMTP credentials in `email.properties` are stored in plaintext.
  Move them to external properties or environment variables before deploying to production.
- Production database credentials in `DataSource.groovy` (`usr`/`sa`) are default placeholders.
  Change both the username and password, and restrict MySQL grants to `localhost` only.
- The `console/` plugin provides a live Groovy REPL. Ensure it is excluded from production builds
  or protected behind a firewall rule — it grants arbitrary code execution on the server.
- Authentication is handled by **Spring Security Core 1.2.7.3**. URL access rules are defined
  in the `interceptUrlMap` block in `Config.groovy`. All controllers require authentication
  (`IS_AUTHENTICATED_REMEMBERED`) unless explicitly listed as anonymous.
- Passwords are hashed with **BCrypt** (via Spring Security's `springSecurityService.encodePassword()`).
  New users created through the UI or `UserManagementService` automatically receive BCrypt hashes.
- **Existing database users** (pre-migration from SHA-256) will have their passwords rejected on
  first login. Use the admin UI (`/userSetup`) to reset their passwords after deploying.

---

## 16. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `ClassNotFoundException: com.mysql.jdbc.Driver` | MySQL connector not on classpath | Verify `lib/mysql-connector-java-5.1.6-bin.jar` is included in the WAR |
| `Communications link failure` on startup | MySQL not running or wrong host | Check `systemctl status mysqld`; verify `-DdbHostName` |
| Bootstrap runs but app shows 404 | WAR deployed to wrong context path | Access via `/pricewell/` not `/` |
| `OutOfMemoryError: PermGen` | Default JVM too small for Grails 2 | Add `-XX:MaxPermSize=256m` to `CATALINA_OPTS` |
| SOW generation fails with `FileNotFoundException` | `SOWFiles/` path not found | Verify Tomcat's working directory contains `SOWFiles/` or use an absolute path in `GenerateSOWService` |
| Uploads fail silently | `uploadedFiles/` not writable | `chown tomcat:tomcat /var/pricewell/uploadedFiles` |
| Emails not sent | SMTP config wrong | Check `web-app/props/email.properties` SMTP block |
| Login page shows 404 | Auth URL mapping missing | Verify `/auth/login` mapping in `UrlMappings.groovy`; access via `/pricewell/auth/login` |
| Existing user can't log in after migration | SHA-256 password hash incompatible with BCrypt | Reset password via admin UI at `/userSetup` |
| Session expires immediately | Session timeout misconfigured | Check `WebXmlConfig.groovy` — default is 480 minutes |

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Sales automation and pricing platform for professional services organizations. Automates development, presentation, and accounting for service projects — including pricing strategy, quotation generation, and Statement of Work (SOW) creation.

## Commands

```bash
make          # Build
make check    # Run all tests (outputs JUnit XML to reports/**/*.xml)
make publish  # Deploy

# Grails direct commands (from within a subproject)
grails test-app                              # Run all tests
grails test-app com.example.SomeServiceTests # Run a single test class
grails test-app com.example.SomeService.testMethod  # Run a single test method
grails run-app                               # Start development server
```

CI pipeline (Jenkins): Build → Test → Deploy.

**Databases:**
- Development/Production: MySQL (`jdbc:mysql://localhost:3306/smp_pricewell`, user: `root`)
- Tests: H2 in-memory (`jdbc:h2:mem:testDb`) — auto-configured, no setup needed

## Architecture

### Monorepo Structure

Grails 1.3.6 monolithic application with a plugin-based decomposition:

| Directory | Purpose |
|-----------|---------|
| `pricewell/` | Main application — 70 controllers, 47 services, 79 GSP view directories |
| `pricewellDomain/` | 66 domain/entity objects (GORM models) and Nimble overrides |
| `nimble/` | Authentication & RBAC plugin (Apache Shiro, SHA-256 credentials) |
| `connectwiseIntegration/` | Two-way sync with ConnectWise PSA |
| `clarizenIntegration/` | Integration with Clarizen project management |
| `salesforceIntegration/` | Salesforce CRM integration |
| `calendar/` | Date picker UI component (GSP taglib) |
| `console/` | Groovy REPL console (dev tooling) |

### Request Flow

```
HTTP Request
  → Controller (beforeInterceptor logs action)
  → Service (transactional business logic)
  → Domain object / GORM / MySQL
  → GSP view or JSON response
```

### Key Services (`pricewell/grails-app/services/`)

- `PriceCalculationService` — role-based rate card pricing (BigDecimal with ROUND_HALF_EVEN)
- `QuotationService` — multi-level approval workflow (SalesManager → GeneralManager → SalesPresident)
- `GenerateSOWService` — Statement of Work document generation; note hard-coded path `G:/SOWFiles/`
- `MyPDFService` — HTML-to-PDF via Flying Saucer / ITextRenderer
- `ConnectwiseCatalogService` / `CwimportService` — ConnectWise sync
- `SalesforceCatalogService` — Salesforce sync

### Security & Multi-tenancy

Five predefined roles: `SYSTEM ADMINISTRATOR`, `PORTFOLIO MANAGER`, `PRODUCT MANAGER`, `SERVICE DESIGNER`, `SALES PERSON`.

Data access is scoped geographically (Geo → GeoGroup). Sales users see only their assigned accounts; managers see territories; admins see all. `SecurityUtils.subject` (Shiro) is used throughout controllers and domain static methods for role checks.

### Quotation Workflow States (Staging table)

`INITIAL → GENERATED → SENT → CUSTOMER_RECEIVED → REJECTED / EDITED → ACCEPTED`

Review requests require 3-level approval: `requestLevel1` (SalesManager), `requestLevel2` (GeneralManager), `requestLevel3` (SalesPresident).

### Price Calculation

```
Service → ServiceProfile → DeliveryRoles (hours) × RelationDeliveryGeo (rate/day) → Price
```
All monetary values use `BigDecimal` with scale 2 and `ROUND_HALF_EVEN`.

### Document Generation Stack

Flying Saucer (XHTML→PDF) + iText 2.0.8 + docx4j 3.0.0 + Apache Batik (SVG) + hr.ngs.templater (template merging).

### Integration Pattern

Each external system plugin has:
- `*ExporterService` — push data out (opportunities, contacts, service tickets)
- `*ImporterService` — pull data in

ConnectWise uses a custom `XTrustProvider` for SSL/TLS.

## Code Conventions

- Services declare `static transactional = true`
- Domain objects define `static constraints = { ... }` for validation
- Role-aware queries use static methods on domain objects that call `SecurityUtils`
- JSON responses via `render domain as JSON` (grails.converters.JSON)
- Tests extend `GrailsUnitTestCase` (older style) or use `@TestMixin(GrailsUnitTestMixin)` (newer)
- H2 dialect is auto-configured for tests; MySQL dialect is explicit for dev/prod

## Known Issues

- Some incomplete/TODO methods present in services
- Mixed old and new Grails testing styles across the codebase
- Known UI bugs documented in `pricewell/grails-app/KnownBugs.txt`

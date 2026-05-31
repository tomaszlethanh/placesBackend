# Places Backend

A RESTful API backend for a food review application, built with Spring Boot. This project was developed as part of a university dissertation.

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Running Locally](#running-locally)
  - [Running with Docker](#running-with-docker)
- [Configuration](#configuration)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)

---

## Overview

Places Backend provides the server-side logic for a food review platform. It handles user authentication via Firebase, manages place and review data with a PostgreSQL database, and supports full-text search using Hibernate Search with a Lucene backend.

## Tech Stack

| Category | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 3.1.5 |
| Database | PostgreSQL 15 |
| ORM | Spring Data JPA / Hibernate |
| Migrations | Flyway |
| Search | Hibernate Search + Apache Lucene |
| Authentication | Firebase Admin SDK + Spring Security OAuth2 |
| API Docs | SpringDoc OpenAPI (Swagger UI) |
| Containerisation | Docker / Docker Compose |
| Deployment | Fly.io |
| Build Tool | Maven (Maven Wrapper included) |
| Utilities | Lombok, Log4j2 |

## Prerequisites

- Java 17+
- Maven (or use the included `./mvnw` wrapper)
- Docker & Docker Compose (for running PostgreSQL locally)
- A Firebase project with a service account key

## Getting Started

### Running Locally

1. **Clone the repository**

   ```bash
   git clone https://github.com/tomaszlethanh/placesBackend.git
   cd placesBackend
   ```

2. **Start the PostgreSQL database**

   ```bash
   docker-compose up -d
   ```

   This starts a PostgreSQL 15 container on port `5434` (mapped from the container's `5432`).

3. **Set environment variables**

   Export your database connection details and Firebase Admin SDK credentials as environment variables. See [Configuration](#configuration) for the full list.

4. **Run the application**

   ```bash
   ./mvnw spring-boot:run
   ```

   The API will be available at `http://localhost:8080`.

### Running with Docker

1. **Build the JAR**

   ```bash
   ./mvnw clean package -DskipTests
   ```

2. **Build and run the Docker image**

   ```bash
   docker build -t places-backend .
   docker run -p 8080:8080 places-backend
   ```

   The Dockerfile uses `eclipse-temurin:17-jdk-alpine` as the base image and starts the app with the `test` Spring profile active.

## Configuration

The project uses three `application.yml` files:

| File | Profile | Purpose |
|---|---|---|
| `application.yml` | default | Base config — server, security, Flyway settings |
| `application-dev.yml` | `dev` | Local development with Docker Compose PostgreSQL |
| `application-test.yml` | `test` | Deployed environment pointing at Supabase |

The `test` profile is activated automatically when running via Docker (set in the `Dockerfile` as `-Dspring.profiles.active=test`). For local development, activate the `dev` profile:

```bash
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### Database

**Development profile (`dev`)** — uses a local PostgreSQL instance started via Docker Compose:

```bash
docker-compose up -d   # starts postgres on localhost:5434
```

Credentials are hardcoded in `application-dev.yml` (username: `postgres`, password: `postgres`).

**Test/deployed profile (`test`)** — connects to a hosted Supabase PostgreSQL instance. Only the password is injected at runtime via an environment variable:

| Environment Variable | Description |
|---|---|
| `DB_PASSWORD` | Password for the Supabase PostgreSQL database |

Flyway runs migrations automatically on startup in both profiles (`baseline-on-migrate: true`). The schema is fully Flyway-managed (`ddl-auto: none`).

### Full-Text Search (Lucene)

Both profiles configure Hibernate Search with Lucene 9.7.0. The index directory differs per environment:

| Profile | Index directory |
|---|---|
| `dev` | `./search-index` (relative to working directory) |
| `test` | `/data/search-index` (absolute path inside the container) |

When running in Docker, ensure `/data/search-index` is writable inside the container. Mount a volume if you need the index to persist across container restarts.

### Logging

The `dev` profile enables verbose Hibernate SQL logging to assist with debugging:

- SQL statements are printed at `DEBUG` level
- Bind parameter values are printed at `TRACE` level (`BasicBinder`)

### Authentication

JWT authentication is handled by Spring Security's OAuth2 resource server, configured to validate Firebase-issued tokens:

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com
          issuer-uri: https://securetoken.google.com/<your-firebase-project-id>
```

### Firebase Admin SDK

Firebase credentials are read from environment variables. Set the following before running the application:

| Environment Variable | Description |
|---|---|
| `FIREBASE_ADMIN_SDK_TYPE` | Credential type (usually `service_account`) |
| `FIREBASE_ADMIN_SDK_PROJECT_ID` | Firebase project ID |
| `FIREBASE_ADMIN_SDK_PRIVATE_KEY_ID` | Private key ID from the service account JSON |
| `FIREBASE_ADMIN_SDK_PRIVATE_KEY` | Private key (PEM string) |
| `FIREBASE_ADMIN_SDK_CLIENT_EMAIL` | Service account client email |
| `FIREBASE_ADMIN_SDK_CLIENT_ID` | Service account client ID |
| `FIREBASE_ADMIN_SDK_AUTH_URI` | Auth URI |
| `FIREBASE_ADMIN_SDK_TOKEN_URI` | Token URI |
| `FIREBASE_ADMIN_SDK_TOKEN_AUTH_PROVIDER_CERT` | Auth provider X.509 cert URL |
| `FIREBASE_ADMIN_SDK_TOKEN_CLIENT_CERT` | Client X.509 cert URL |
| `FIREBASE_ADMIN_SDK_UNIVERSE_DOMAIN` | Universe domain (usually `googleapis.com`) |

These values can be found in the service account JSON file downloaded from the Firebase Console (**Project Settings → Service Accounts → Generate new private key**).

## API Documentation

Once the application is running, interactive API documentation is available via Swagger UI at:

```
http://localhost:8080/swagger-ui.html
```

The OpenAPI specification (JSON) is available at:

```
http://localhost:8080/v3/api-docs
```

## Project Structure

```
placesBackend/
├── src/
│   └── main/
│       ├── java/com/example/backend/   # Application source code
│       └── resources/                  # Config files & Flyway migrations
├── Dockerfile                          # Container image definition
├── docker-compose.yml                  # Local PostgreSQL setup
├── fly.toml                            # Fly.io deployment config
├── pom.xml                             # Maven dependencies & build config
└── mvnw / mvnw.cmd                     # Maven wrapper scripts
```

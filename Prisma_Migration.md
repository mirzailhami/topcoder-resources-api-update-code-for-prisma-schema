# Prisma Migration Explanation

This document outlines the transformation of the Resources API data model from legacy systems (Informix, DynamoDB, Elasticsearch) to a unified PostgreSQL schema using Prisma ORM. It details Swagger updates, model mappings, verification steps including testing, and migration strategies, adhering to Prisma best practices (e.g., appropriate indexing, consistent naming).

---

## Swagger Updates

Per forum guidance, Swagger updates are based on `src/models/` (not the obsolete `swagger.yaml`). Potential changes are inferred from schema updates:

| API Endpoint         | Controller/Service | Method         | Explanation                                                                                                                                 |
| -------------------- | ------------------ | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `POST /resources`    | ResourceService    | createResource | Input: Matches `Resource.js` (`challengeId`, `memberId`, etc.). Output: Adds audit fields (`created`, `createdBy`, `updated`, `updatedBy`). |
| `GET /resources`     | ResourceService    | getResources   | Output: Includes audit fields and optional `challenge`/`role` relations.                                                                    |
| `GET /resources/:id` | ResourceService    | getResource    | Output: Includes audit fields and optional relations.                                                                                       |

**Notes**:

- Input aligns with `ResourceService.js` Joi schemas.
- Output enhancements (audit fields) reflect schema changes.

---

## Verification

### Running Locally with PostgreSQL

#### Set Up the Environment

1.  **Prisma Init**:

```
npx prisma init
```

2.  **Configure `.env`**:

Add to `.env`:

```
DATABASE_URL="postgresql://<username>@localhost:5432/resources_api_dev?schema=public"
```
- Replace `<username>` with yours (or `postgres` if role fixed).

#### Start PostgreSQL

- **Install PostgreSQL (if dont have, yet)** (via Homebrew on macOS):

```
brew install postgresql@15
brew services start postgresql@15
```

- **Create the Database**:

```
createdb resources_api_dev # Use -U postgres if role exists
```

- **Verify it’s Running**:

```
ps aux | grep postgres
```

Look for `/usr/local/opt/postgresql@15/bin/postgres`.

#### Run Prisma Migrations

```
npx prisma migrate dev --name init
```

Output screenshot (https://monosnap.com/file/vwchihbS45wtDknrtrXeElUrHpOybk).

Applies the schema to PostgreSQL.

#### Test the Schema

1.  **Install Dependencies**:

```
npm install @prisma/client
```

2.  **Run the test.js file**:

```
node test.js
```

Output (https://monosnap.com/file/TiJG4I0gR8z9yJ3wjd7Cxg71uRSyVq).

#### Access Prisma Studio (Optional)

```
npx prisma studio
```

Open http://localhost:5555 to inspect tables (https://monosnap.com/file/wniyAcTIIbxXs3WTFbsfb6CYKh594g).

## Detailed Analysis of Prisma Models Transformation

Models are mapped from `src/models/` ([link](https://github.com/topcoder-platform/resources-api/tree/develop/src/models)), adhering to Prisma best practices: camelCase naming, explicit indexes for query optimization, and audit fields as required.

### 1. Resource

**Purpose**: Represents a resource assigned to a challenge.

- **Legacy Sources**:
  - **DynamoDB**: `Resource.js` with `id`, `challengeId`, `memberId`, `memberHandle`, `roleId`, etc.
  - **Elasticsearch**: Indexed `memberHandle`.
  - **Informix**: Relational `challengeId` links.
- **Transformation**:
  - `id` as UUID replaces string hash key.
  - Composite indexes (`challengeId, memberId`, `memberId, roleId`) preserved from DynamoDB.
  - Audit fields standardized (`created`, `updated` with `@default(now())`, `@updatedAt`).
- **Relationships**: `ResourceRole` (`roleId`), `Challenge` (`challengeId`).

### 2. ResourceRole

**Purpose**: Defines resource roles (e.g., “Developer”).

- **Legacy Sources**:
  - **DynamoDB**: `ResourceRole.js` with `id`, `name`, `fullReadAccess`, `fullWriteAccess`, `isActive`, `selfObtainable`, `legacyId`, `nameLower`.
- **Transformation**:
  - All fields mapped, `id` as UUID.
  - `nameLower` indexed per DynamoDB’s `resourceRole-nameLower-index`.
  - Audit fields added (`created`, `createdBy`, `updated`, `updatedBy`).
- **Relationships**: One-to-many with `Resource`, `ResourceRolePhaseDependency`.

### 3. ResourceRolePhaseDependency

**Purpose**: Links roles to phases with state flags.

- **Legacy Sources**:
  - **DynamoDB**: `ResourceRolePhaseDependency.js` with `id`, `phaseId`, `resourceRoleId`, `phaseState`.
- **Transformation**:
  - `phaseState` replaces `dependentOn` for code fidelity.
  - Indexes on `phaseId`, `resourceRoleId` added for query efficiency.
  - Audit fields included.
- **Relationships**: `ResourceRole` (`resourceRoleId`), `Phase` (`phaseId`).

### 4. MemberStats

**Purpose**: Stores member statistics.

- **Legacy Sources**:
  - **DynamoDB**: `MemberStats.js` with `userId`, `handle`, `handleLower`, `maxRating`.
- **Transformation**:
  - `maxRating` as `Json` for unstructured data.
  - `handleLower` indexed per DynamoDB’s `handleLower-index`.
  - Audit fields added.
- **Relationships**: None.

### 5. MemberProfile

**Purpose**: Holds member profile details.

- **Legacy Sources**:
  - **DynamoDB**: `MemberProfile.js` with `userId`, `handle`, `handleLower`, `email`.
- **Transformation**:
  - Fields mapped directly, `handleLower` indexed.
  - Audit fields included.
- **Relationships**: None.

### 6. Challenge (Inferred)

**Purpose**: Supports `Resource.challengeId`.

- **Legacy Sources**:
  - **Informix/DynamoDB**: `challengeId` references.
- **Transformation**:
  - Minimal fields (`id`, `name`, etc.), `projectId` indexed.
  - Audit fields added.
- **Relationships**: One-to-many with `Resource`.

### 7. Phase (Inferred)

**Purpose**: Supports `ResourceRolePhaseDependency.phaseId`.

- **Legacy Sources**:
  - **Informix/DynamoDB**: `phaseId` references.
- **Transformation**:
  - Minimal fields (`id`, `name`), `name` uniquely indexed.
  - Audit fields added.
- **Relationships**: One-to-many with `ResourceRolePhaseDependency`.

---

## Recommended Migration Methodologies and Tools

- **Incremental Migration**:
  - Export DynamoDB to CSV via AWS CLI.
  - Use Node.js scripts to transform and import into Postgres.
- **Verification**:
  - Compare record counts with `prisma studio` or SQL queries.
- **Tools**:
  - **Prisma Migrate**: `npx prisma migrate dev` for schema application.
  - **pgAdmin**: Manual SQL validation.
  - **AWS Data Pipeline**: For large-scale exports.

---

This schema consolidates the Resources API into Postgres, adhering to Prisma best practices: camelCase naming, indexes on frequently queried fields (e.g., `challengeId`, `nameLower`), and consistent audit fields per challenge requirements.
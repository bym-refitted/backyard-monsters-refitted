# Server Architecture

> A comprehensive overview of the `server` project architecture and folder organization.

The server is built on a modern Node.js architecture using Koa.js, TypeScript, and MikroORM. This modular structure separates concerns across distinct layers - from API endpoints and business logic to data models and utilities. Each folder serves a specific purpose in the application's ecosystem, enabling scalable development and easy maintenance. The codebase follows clean architecture principles with clear separation between controllers, services, and data access layers, making it straightforward for developers to locate and modify specific functionality.
<br>

<br>

### Entry Points & Core Configuration

```
📦 server/public/  
└── Static game assets, language files, and templates

📦 server/src/ 
├── server.ts                  # Main Koa server entry point  
├── app.routes.ts              # Central API route definitions  
├── mikro-orm.config.ts        # PostgreSQL & ORM setup  
└── seed.ts                    # Database seeding utilities
```

<br>

## 📂 Configuration Layer
**`config/`** - Server configuration and settings

| File | Purpose |
|------|---------|
| `DevSettings.ts` | Development flags & feature toggles |
| `MailSettings.ts` | SMTP mailer configuration |
| `WorldGenSettings.ts` | World generation parameters |

<br>

## 📂 Controllers Layer
**`controllers/`** - Request handlers organized by feature domain

```
📦 controllers/
└── 📦 auth/                    # Authentication & authorization
└── 📦 base/                    # Core base management (load/save/update)
└── 📦 debug/                   # Debug endpoint the client sends logs to
└── 📦 events/                  # Game events handling
└── 📦 leaderboards/            # Player rankings & scores
└── 📦 mail/                    # In-game messaging system
└── 📦 maproom/                 # Map Room system
└── 📦 attacklogs/              # Combat logging & history
└── 📦 yardplanner/             # Base planning & layout tools
```

<br>

## 📂 Data & Constants
**`data/`** - Static game data and configuration constants

| Category | Files | Description |
|----------|-------|-------------|
| **Game Stats** | `championStats.ts`, `experiencePoints.ts`, `monsterStats.ts` | Static game data e.g. stats for monsters |
| **Game Config** | `flags.ts`, `monsterKeys.ts` | Game flags & identifiers |
| **Content** | `store/`, `tribes/` | Store items & tribe data |

<br>

## 📂 Database Layer
**`database/`** - Migration scripts and database seeding utilities

<br>

## 📂 Development Tools
**`dev/`** - Development sandbox bases used to load populated pre-configured test yards, which can be enabled in `DevSettings.ts`

<br>

## 📂 Type Definitions
**`enums/`** - TypeScript enums for consistent game logic
- Status codes, base types, game states, and more

<br>

## 📂 Error Management
**`errors/`** - Centralized error definitions and handling

<br>

## 📂 Middleware Stack
**`middleware/`** - Koa middleware components
- API versioning, authentication, error handling
- Logging, CORS, request validation

<br>

## 📂 Data Models
**`models/`** - ORM entity definitions
- Users, saves, worlds, messages, threads
- Attack logs, leaderboards, and more

<br>

## 📂 Automation Scripts
**`scripts/`** - Utility and maintenance scripts
- Anticheat systems, data processing, cleanup tasks

<br>

## 📂 Business Logic
**`services/`** - Core business logic and helper services
- Base updates, maproom operations, game mechanics

<br>

## 📂 Utilities
**`utils/`** - Common utility functions
- Logging, date/time operations, formatting

<br>

### 📂 Validation Layer
**`zod/`** - Request validation schemas
- Type-safe API input validation using Zod

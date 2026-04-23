# Feature: Dashboard

> SOW reference: v1.4  
> Status: ✅ Complete (local data) · ⏳ Live data pending middleware spec

---

## User Flow

```
Authenticated user (returning session)
    ↓
DashboardPage (/dashboard)
    ├── Drafts section     → tap → AssetFormPage (resume draftId)
    └── Submitted section  → tap → SubmissionDetailPage
         └── (if accepted/listed) → ValuationResponsePage

FAB "New Submission" → ItemQuantityRoutingPage (/routing)
```

---

## File Map

```
lib/features/dashboard/
├── domain/
│   ├── entities/
│   │   └── submission_summary.dart     SubmissionSummary + SubmissionStatus enum
│   ├── repositories/
│   │   └── dashboard_repository.dart   Abstract interface
│   └── usecases/
│       └── watch_dashboard_items.dart  Callable use case
├── data/
│   └── repositories/
│       └── dashboard_repository_impl.dart  Drift queries + rxdart combineLatest3
└── presentation/
    ├── bloc/
    │   ├── dashboard_bloc.dart          @injectable factory
    │   ├── dashboard_event.dart         part file
    │   └── dashboard_state.dart         part file
    ├── pages/
    │   └── dashboard_page.dart          Main page + nested views
    └── widgets/
        ├── submission_card.dart         Single list item
        ├── sync_status_banner.dart      Syncing / failed animated banner
        └── empty_dashboard.dart         Zero-state illustration
```

---

## Domain Entity: `SubmissionSummary`

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID — draft ID or submitted asset ID |
| `assetLabel` | `String` | Human-readable name for list display |
| `assetCategory` | `String` | Category key, e.g. `"vehicles"`, `"industrial"` |
| `status` | `SubmissionStatus` | See enum table below |
| `updatedAt` | `DateTime` | Sort key — `updatedAt` for drafts, `lastUpdatedAt` for submitted |
| `remoteId` | `String?` | CRM-assigned ID; `null` for local drafts |
| `photoCount` | `int?` | Number of attached photos; `null` for submitted assets |
| `lastSyncError` | `String?` | Last error message when `status == syncFailed` |

### Computed Properties

| Property | Value |
|---|---|
| `isLocal` | `true` when status is `draft`, `queued`, `syncing`, or `syncFailed` |
| `hasValuation` | `true` when status is `accepted` or `listed` |

---

## `SubmissionStatus` Enum

| Value | Source | Display label |
|---|---|---|
| `draft` | Local, no sync queue entry | Draft |
| `queued` | SyncQueue: `pending` | Queued |
| `syncing` | SyncQueue: `in_progress` | Syncing |
| `syncFailed` | SyncQueue: `failed` | Sync Failed |
| `submitted` | CRM status (default) | Submitted |
| `valuationPending` | CRM: `valuation_pending` | Valuation Pending |
| `accepted` | CRM: `accepted` | Accepted |
| `listed` | CRM: `listed` | Listed |

Status colour tokens (from `AppColours`):
`statusDraft` · `statusQueued` · `statusSyncing` · `statusSubmitted` · `statusValuationPending` · `statusAccepted` · `statusListed`

---

## Repository

`DashboardRepository.watchAllItems()` returns `Stream<List<SubmissionSummary>>`.

`DashboardRepositoryImpl` uses `Rx.combineLatest3` over three Drift watch streams:
1. `SubmissionDrafts` (ordered by `updatedAt DESC`)
2. `SyncQueue` (all entries; indexed by `submissionId` for O(1) join)
3. `SubmittedAssets` (ordered by `lastUpdatedAt DESC`)

The implementation builds `SubmissionSummary` lists from both sources and merges + sorts the result by `updatedAt DESC`.

---

## Bloc

### Events

| Event | Who dispatches | Effect |
|---|---|---|
| `DashboardStarted` | `DashboardPage` on mount | Emits `DashboardLoading`; starts item + sync-status stream subscriptions |
| `DashboardSyncRequested` | FAB pull-to-refresh / sync banner tap | Calls `SyncEngine.syncNow()` (fire-and-forget) |
| `_ItemsReceived` | Items stream subscription | Emits `DashboardLoaded` with updated items |
| `_ItemsErrorReceived` | Items stream error handler | Emits `DashboardError` |
| `_SyncStatusReceived` | Sync status stream subscription | Updates `syncStatus` in `DashboardLoaded` if currently loaded |

### States

| State | When | Fields |
|---|---|---|
| `DashboardInitial` | Before first event | — |
| `DashboardLoading` | During startup | — |
| `DashboardLoaded` | Data available | `items`, `syncStatus`, derived `drafts` + `submitted` + `isEmpty` |
| `DashboardError` | Stream error | `message` |

---

## Pages & Widgets

### `DashboardPage`
- Provides `DashboardBloc` via `BlocProvider(create: getIt<DashboardBloc>())`.
- Dispatches `DashboardStarted` immediately on creation.

### `_DashboardView`
- AppBar: "My Submissions" · Profile icon → `/profile` · Help icon → `/help`
- FAB: "New Submission" → `Routes.itemQuantityRouting`
- Body switches on state: loading spinner / error + retry / loaded content

### `_LoadedBody`
- Shows `EmptyDashboard` when `state.isEmpty`.
- Otherwise: `SyncStatusBanner` + `RefreshIndicator` wrapping `CustomScrollView`.
- Drafts section (if any) → `_SectionHeader` + `_SubmissionSliver`
- Submitted section (if any) → `_SectionHeader` + `_SubmissionSliver`
- Pull-to-refresh dispatches `DashboardSyncRequested`.

### `SubmissionCard`
- Shows category icon, asset label (2-line), category, photo count, relative date.
- Status chip uses colour tokens; `syncing` shows an inline `CircularProgressIndicator`.
- `syncFailed` shows last error message inline.
- Chevron on trailing edge.

### `SyncStatusBanner`
- Animated height transition (250 ms ease-in-out) — zero height when idle.
- Syncing: blue container, spinner, "Syncing submissions…"
- Failed: error container, tap to dispatch `DashboardSyncRequested`.

### `EmptyDashboard`
- Circular icon placeholder, headline, body copy, "New Submission" button.

---

## Category Icon Map

| Category key(s) | Icon |
|---|---|
| `vehicles`, `vehicle` | `Icons.directions_car_outlined` |
| `trucks`, `truck` | `Icons.local_shipping_outlined` |
| `trailers`, `trailer` | `Icons.rv_hookup_outlined` |
| `industrial`, `machinery` | `Icons.precision_manufacturing_outlined` |
| `earthmoving` | `Icons.construction_outlined` |
| `agricultural`, `farm` | `Icons.agriculture_outlined` |
| `marine`, `boats` | `Icons.directions_boat_outlined` |
| (default) | `Icons.inventory_2_outlined` |

---

## DI Registration

`DashboardRepositoryImpl` and `WatchDashboardItems` are annotated `@injectable` /
`@LazySingleton` and are resolved by the generated `injection.config.dart`.

`AppDatabase` is registered as a `lazySingleton` manually in `injection.dart`
(required because `AppDatabase` has no injectable annotation — it is a generated
Drift class).

---

## Pending Work

| Item | Blocked on |
|---|---|
| `SubmittedAssets` populated from server | Middleware OpenAPI spec → `SubmissionSyncService` impl |
| Push notification deep-link to submission detail | Firebase Messaging setup |
| Valuation badge / count on dashboard | After `ValuationResponsePage` is built |

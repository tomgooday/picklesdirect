# Feature: Bulk Lead Capture (`features/bulk_lead_capture`)

> **SOW refs:** BR-07A – BR-07G, Step 1a routing (SOW v1.4)  
> **Status:** Domain, Bloc, and UI complete. Repository implementation pending middleware spec.

---

## Contents

1. [Overview](#overview)
2. [User Flow](#user-flow)
3. [File Map](#file-map)
4. [Domain Layer](#domain-layer)
5. [Bloc Layer](#bloc-layer)
6. [Pages & Widgets](#pages--widgets)
7. [Routing](#routing)
8. [Pending Work](#pending-work)
9. [Test Coverage](#test-coverage)

---

## Overview

The Bulk Lead Capture flow is designed for vendors who have **2 or more assets** to sell. Rather than completing a detailed Long Form for each asset, the vendor submits a lightweight lead that captures:

- Vendor contact details (name, phone, email)
- A list of asset types with make, model, and approximate quantity

The lead is routed to Pickles AutoCheck with an origin flag of `"Bulk Lead"` for manual triage by the Pickles Direct team.

**What Bulk Lead does NOT capture** (compared to Long Form):
- Photos
- Serial numbers / VINs
- Detailed condition assessment
- GPS location

---

## User Flow

```
ItemQuantityRoutingPage
    └── "2 or more items" tapped
            ↓
        BulkLeadPage
            ├── Fill vendor contact: name, phone, email
            ├── Select asset types (multi-select expandable list)
            │   └── For each selected type: Make, Model, Quantity (inline fields)
            └── "Submit Lead" button
                    ↓
                BulkLeadConfirmationPage
                    ├── Success message
                    ├── Reference number (from API response)
                    └── "Submit another" / "Go to Dashboard" CTAs
```

---

## File Map

```
lib/features/bulk_lead_capture/
├── domain/
│   ├── entities/
│   │   └── bulk_lead.dart                  # BulkLead + BulkLeadAssetItem entities
│   ├── repositories/
│   │   └── bulk_lead_repository.dart       # Abstract interface
│   └── usecases/
│       └── submit_bulk_lead.dart           # Pre-submission validation + submit
│
└── presentation/
    ├── bloc/
    │   ├── bulk_lead_bloc.dart             # Bloc
    │   ├── bulk_lead_event.dart            # (part file)
    │   └── bulk_lead_state.dart            # (part file)
    ├── pages/
    │   ├── bulk_lead_page.dart             # Main form page
    │   └── bulk_lead_confirmation_page.dart
    └── widgets/
        ├── vendor_contact_fields.dart      # Reusable vendor name/phone/email fields
        └── asset_type_selector.dart        # Multi-select asset types with inline inputs
```

---

## Domain Layer

### `BulkLead` entity

| Field | Type | Validation |
|-------|------|------------|
| `id` | `String` | UUID generated client-side |
| `vendorName` | `String` | Non-empty |
| `phone` | `String` | Non-empty |
| `email` | `String` | Non-empty |
| `assetItems` | `List<BulkLeadAssetItem>` | Min 1 item, all items must be valid |
| `status` | `BulkLeadStatus` | draft / submitting / submitted / failed |
| `submittedAt` | `DateTime?` | Set on successful submission |

```dart
bool get isReadyToSubmit =>
    vendorName.trim().isNotEmpty &&
    phone.trim().isNotEmpty &&
    email.trim().isNotEmpty &&
    assetItems.isNotEmpty &&
    assetItems.every((item) => item.isValid);
```

### `BulkLeadAssetItem` entity

| Field | Type | Notes |
|-------|------|-------|
| `assetTypeKey` | `String` | Schema key, e.g. `"excavator"`, `"trucks"` |
| `assetTypeLabel` | `String` | Human-readable display label |
| `quantity` | `int` | Approximate count (BR-07E) |
| `make` | `String?` | Manufacturer (BR-07C) |
| `model` | `String?` | Model (BR-07D) |

```dart
bool get isValid => assetTypeKey.isNotEmpty && quantity >= 1;
```

### `BulkLeadRepository` interface

```dart
abstract interface class BulkLeadRepository {
  Future<Either<Failure, String>> submitBulkLead(BulkLead lead);
  // Returns the server-assigned reference number on success.
}
```

### `SubmitBulkLead` use case

Validates `lead.isReadyToSubmit` before calling the repository. Returns `ValidationFailure` if the lead is incomplete, otherwise delegates to the repository.

---

## Bloc Layer

### Events

| Event | Payload | When |
|-------|---------|------|
| `BulkLeadVendorDetailsChanged` | `name`, `phone`, `email` | Any contact field changes |
| `BulkLeadAssetTypeToggled` | `assetTypeKey`, `assetTypeLabel` | User selects/deselects an asset type |
| `BulkLeadAssetDetailChanged` | `assetTypeKey`, `make`, `model`, `quantity` | Inline make/model/qty changes |
| `BulkLeadSubmitted` | — | "Submit Lead" button tapped |

### States

| State | Notes |
|-------|-------|
| `BulkLeadInitial` | Empty form |
| `BulkLeadFormUpdated` | lead, formStatus (valid/invalid/submitting) |
| `BulkLeadSubmitting` | Loading state |
| `BulkLeadSubmitSuccess` | referenceNumber (from API) |
| `BulkLeadSubmitFailure` | failure (Failure type) |

### Form status

`BulkLeadFormStatus.valid` only when `lead.isReadyToSubmit == true`. The submit button is enabled only in this state.

---

## Pages & Widgets

### `BulkLeadPage`

- Wraps `BulkLeadBloc` via `BlocProvider`.
- Scrollable form with two sections:
  1. **Vendor contact** — rendered by `VendorContactFields` widget.
  2. **Asset types** — rendered by `AssetTypeSelector` widget.
- "Submit Lead" button is enabled only when `BulkLeadFormStatus.valid`.
- On `BulkLeadSubmitSuccess` → navigates to `Routes.bulkLeadConfirmation`.
- On `BulkLeadSubmitFailure` → shows error SnackBar; form remains editable.

### `BulkLeadConfirmationPage`

- Success icon + confirmation message.
- Displays reference number from the API response.
- Two CTAs:
  - "Submit Another" → `context.go(Routes.itemQuantityRouting)` to restart the flow.
  - "Go to Dashboard" → `context.go(Routes.dashboard)`.

### `VendorContactFields` widget

```dart
VendorContactFields(
  onChanged: (name, phone, email) => bloc.add(
    BulkLeadVendorDetailsChanged(name: name, phone: phone, email: email),
  ),
)
```

Contains name, phone, and email fields with inline validation. Reusable — can be embedded in other forms.

### `AssetTypeSelector` widget

```dart
AssetTypeSelector(
  selectedItems: state.lead.assetItems,
  onAssetTypeToggled: (key, label) => bloc.add(...),
  onAssetDetailChanged: (key, make, model, qty) => bloc.add(...),
)
```

- Expandable list of asset type options.
- When an asset type is selected, inline fields for Make, Model, and Quantity appear.
- Asset type list is currently hardcoded; will be driven by the `AssetSchemas` cache once the middleware schema spec is available.

---

## Routing

- Entry point: `Routes.bulkLead` (`/bulk-lead`).
- Accessed from `ItemQuantityRoutingPage` when the user selects "2 or more items".
- On successful submission: navigates to `Routes.bulkLeadConfirmation` (`/bulk-lead/confirmation`).
- Both routes are defined outside the `ShellRoute` — they don't share the bottom navigation shell.

---

## Pending Work

| Item | Blocked on |
|------|-----------|
| `BulkLeadRepositoryImpl` | Middleware API spec (endpoint, request/response schema) |
| Asset type list from middleware | Middleware schema spec — currently hardcoded |
| Offline queuing for bulk leads | Decision: bulk leads are lightweight; may not need offline queue |

---

## Test Coverage

**File:** `test/features/bulk_lead_capture/bulk_lead_bloc_test.dart`

| Test | Description |
|------|------------|
| `BulkLeadVendorDetailsChanged — updates vendor name` | State reflects name change |
| `BulkLeadAssetTypeToggled — adds asset type` | AssetItem added to list |
| `BulkLeadAssetTypeToggled — removes asset type` | AssetItem removed from list |
| `BulkLeadSubmitted — success` | Emits `[BulkLeadSubmitting, BulkLeadSubmitSuccess]` |
| `BulkLeadSubmitted — incomplete lead` | Emits `BulkLeadSubmitFailure` with ValidationFailure |
| `BulkLeadSubmitted — repository error` | Emits `BulkLeadSubmitFailure` with network/server failure |

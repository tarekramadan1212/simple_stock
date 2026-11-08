# Simple Stock - Software Design & Architecture Document

## 1. Executive Summary & Overview
**Simple Stock** is a lightweight, mobile-first multi-tenant ERP solution tailored for small businesses. It enables shop owners to manage inventory, track purchases from suppliers, generate digital invoices, and share invoices directly with customers via WhatsApp—eliminating the need for expensive hardware setups (PCs, thermal printers, complex desktop software).

---

## 2. Technical Stack & Core Dependencies

- **Framework**: Flutter (iOS & Android)
- **Architecture**: Feature-First Clean Architecture
- **State Management**: `flutter_bloc` / Cubit
- **Dependency Injection**: `get_it`
- **Functional Programming / Error Handling**: `fpdart` or `dartz` (`Either<Failure, Success>`)
- **Backend & Database**: Firebase Cloud Firestore & Firebase Auth
- **PDF & Printing**: `pdf`, `printing`
- **Utility & Integrations**: `url_launcher` (WhatsApp sharing), `equatable`, `intl`

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  get_it: ^7.6.0
  dartz: ^0.10.1
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  pdf: ^3.10.8
  printing: ^5.13.0
  url_launcher: ^6.3.0
  equatable: ^2.0.5
  intl: ^0.19.0
```

---

## 3. UI Theme & Styling Guidelines

- **Primary Color**: Dark Green (`Color(0xFF1B4D3E)` / `Color(0xFF0F382C)`)
- **Accent Color**: Soft Emerald (`Color(0xFF2E8B57)`)
- **Background Color**: Crisp Light Grey / White (`Color(0xFFF8F9FA)`)
- **Surface & Cards**: Pure White (`#FFFFFF`) with subtle elevation
- **Typography**: Clean, high-legibility sans-serif fonts

---

## 4. Multi-Tenant Architecture & Data Model (Firebase Cloud Firestore)

The application uses **Tenant Isolation at the Firestore Document Level**. Each shop operates within its own `shops/{tenantId}` tree. Global license keys are stored in a top-level collection managed by the system admin.

### 4.1 Collections Structure

```text
/licenses/{licenseId}
/shops/{tenantId}
  ├── profile (document)
  ├── stock_items/{itemId}
  ├── parties/{partyId}
  ├── purchases/{purchaseId}
  └── invoices/{invoiceId}
```

### 4.2 Data Models Schema Definitions

#### A. License Key Document (`/licenses/{licenseId}`)
```json
{
  "id": "LICENSE_KEY_STRING",
  "isUsed": false,
  "assignedShopId": null,
  "createdAt": "Timestamp",
  "expiresAt": "Timestamp"
}
```

#### B. Shop Profile Document (`/shops/{tenantId}/profile/details`)
```json
{
  "tenantId": "string",
  "licenseKey": "string",
  "shopName": "string",
  "email": "string",
  "phoneNumber": "string",
  "address": "string",
  "taxNumber": "string?",
  "createdAt": "Timestamp"
}
```

#### C. Stock Item (`/shops/{tenantId}/stock_items/{itemId}`)
```json
{
  "id": "string",
  "name": "string",
  "costPrice": 0.0,
  "sellingPrice": 0.0,
  "quantity": 0,
  "updatedAt": "Timestamp"
}
```

#### D. Party / Supplier (`/shops/{tenantId}/parties/{partyId}`)
```json
{
  "id": "string",
  "name": "string",
  "phone": "string",
  "type": "SUPPLIER | CUSTOMER | BOTH",
  "address": "string?"
}
```

#### E. Purchase Order (`/shops/{tenantId}/purchases/{purchaseId}`)
```json
{
  "id": "string",
  "partyId": "string",
  "partyName": "string",
  "itemId": "string",
  "itemName": "string",
  "quantity": 10,
  "unitCostPrice": 50.0,
  "totalAmount": 500.0,
  "purchaseDate": "Timestamp"
}
```

#### F. Invoice / Sale (`/shops/{tenantId}/invoices/{invoiceId}`)
```json
{
  "id": "string",
  "invoiceNumber": "INV-1001",
  "customerName": "string?",
  "customerPhone": "string",
  "partyTaxId": "string?",
  "isTaxInvoice": false,
  "items": [
    {
      "itemId": "string",
      "itemName": "string",
      "quantity": 2,
      "unitPrice": 75.0,
      "warrantyPeriod": "6 Months"
    }
  ],
  "totalAmount": 150.0,
  "createdAt": "Timestamp"
}
```

---

## 5. Folder & Project Structure (Clean Architecture - Feature First)

```text
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── service_locator/
│   │   └── injection.dart
│   ├── utils/
│   │   ├── pdf_generator.dart
│   │   └── whatsapp_launcher.dart
│   └── usecases/
│       └── usecase.dart
└── features/
    ├── auth_license/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_data_source.dart
    │   │   ├── models/
    │   │   │   └── shop_profile_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── shop_profile.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── validate_license.dart
    │   │       ├── save_shop_profile.dart
    │   │       └── login_with_email_password.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       └── pages/
    │           ├── license_key_page.dart
    │           ├── shop_setup_page.dart
    │           └── login_page.dart
    │
    ├── inventory/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       │   └── inventory_cubit.dart
    │       └── pages/
    │           ├── stock_search_page.dart
    │           └── purchase_entry_page.dart
    │
    ├── invoicing/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       │   └── invoice_cubit.dart
    │       └── pages/
    │           ├── create_invoice_page.dart
    │
    └── profile_reports/
        ├── data/
        ├── domain/
        └── presentation/
            ├── bloc/
            │   └── reports_cubit.dart
            └── pages/
                └── shop_profile_reports_page.dart
```

---

## 6. Functional Specification & User Flows

### 6.1 Authentication & Tenant Onboarding Flow
1. **License Verification**: User submits license key -> App checks `/licenses/{key}` document in Firestore.
2. **First-Time Setup (`isUsed == false`)**:
   - Direct user to **Shop Setup Screen**.
   - User enters Shop Name, Email, Phone Number, Address, Password, and Password Confirmation (Note: `ownerName` is omitted).
   - Firebase Auth user account is created.
   - System registers tenant document (`/shops/{tenantId}/profile`), links `assignedShopId` to the license, and marks license `isUsed = true`.
3. **Existing Tenant / Device Addition (`isUsed == true`)**:
   - If the license key entered is already marked as `isUsed == true`, the app identifies the associated `assignedShopId` and immediately redirects the user to the **Login Page**.
   - User enters their registered Email and Password to authenticate and log in.
4. **Session Persistence**: App securely caches active `tenantId` and session state locally so the shop doesn't need to sign in every time the app opens.

### 6.2 Stock Purchasing Flow
1. User searches/selects existing item OR types a new item name.
2. User searches/selects existing supplier party OR inputs a new party.
3. User enters quantity and unit cost price.
4. **Transaction Logic**:
   - Save purchase log under `/shops/{tenantId}/purchases`.
   - Update/Create item stock quantity: `newQuantity = oldQuantity + enteredQuantity`.

### 6.3 Stock Search Flow
1. Simple search bar filtering items by `itemName`.
2. Each search item card displays:
   - **Item Name**
   - **Current Quantity**
   - **Cost Price**

### 6.4 Invoicing & Digital Distribution Flow
1. User selects items from inventory, inputs selling price, quantity, and optional warranty.
2. Option to add Customer Phone Number & Party Name (for B2B / Tax Invoices).
3. Tap **Generate & Share Invoice**:
   - Deducts sold quantities from `/shops/{tenantId}/stock_items`.
   - Creates PDF binary using `pdf` package.
   - Saves PDF temporarily locally.
   - Calls `url_launcher` with format: `https://wa.me/{customerPhone}?text={encodedMessage}` and opens WhatsApp directly to send the invoice document.

### 6.5 Profile & Business Reports Flow
1. Display current shop settings.
2. **Sales Summary Report**: Total sales revenue, total invoices issued within date range filters.
3. **Purchase Summary Report**: Total spending on stock purchases within date range filters.

---

## 7. Mandatory AI Coding Instructions & Rules

Any AI agent interacting with this codebase **must strictly follow these guidelines**:

1. **Clean Separation of Concerns**:
   - **NO business logic in `build()` methods** or Widget classes. All state mutations must trigger events or methods on BLoCs/Cubits.
   - Presentation layer depends *only* on Domain Use Cases / Cubits.
   - Data layer handles JSON serialization and API/Firestore calls.

2. **SOLID Principles Enforcement**:
   - **Single Responsibility**: Widgets display UI; BLoCs handle state; Repositories handle data.
   - **Dependency Inversion**: High-level domain code relies on abstract Repository interfaces, not concrete implementations. Inject all dependencies using `GetIt`.

3. **No Over-Engineering**:
   - Keep classes concise and focused. Do not introduce premature abstractions.
   - Use standard `MaterialApp` Flutter navigation (`Navigator.push` / `Navigator.pop`) as specified in project constraints.

4. **Error & Failure Handling**:
   - Wrap repository calls in `Either<Failure, Success>` types using `dartz` or `fpdart`.
   - Handle exceptions inside the Data layer and convert them into readable `Failure` objects for the UI.

5. **Immutability**:
   - BLoC/Cubit states must extend `Equatable` to ensure UI re-renders only on real state changes.
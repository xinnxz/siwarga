# 🔐 03 — Security Architecture

> **Version**: 1.0.0 | **Updated**: 2026-04-28

---

## 1. Security Principles

| Principle | Implementation |
|-----------|---------------|
| **Least Privilege** | Users only access what they need based on role |
| **Defense in Depth** | Multiple security layers (Auth + Rules + Validation) |
| **Data Minimization** | Only collect necessary personal data |
| **Secure by Default** | All routes require auth, opt-in for public |

---

## 2. Authentication Architecture

### 2.1 Auth Flow

```
┌─────────────────────────────────────────────────┐
│                 AUTH FLOW                         │
│                                                  │
│  REGISTRATION (Admin Only)                       │
│  ═══════════════════════                         │
│  Admin → "Tambah Warga" → Input data            │
│       → Firebase.createUser(email, pass)         │
│       → Store profile in Firestore users/        │
│       → Give credentials to warga                │
│                                                  │
│  LOGIN (Warga)                                   │
│  ═════════════                                   │
│  Warga → Input email + password                  │
│        → Firebase.signIn()                       │
│        → Get auth token                          │
│        → Fetch user profile from Firestore       │
│        → Route to Home (based on role)           │
│                                                  │
│  SESSION                                         │
│  ═══════                                         │
│  • Firebase Auth persists session automatically  │
│  • Token auto-refreshes every 1 hour             │
│  • Logout clears session + FCM token             │
│                                                  │
│  PASSWORD RESET                                  │
│  ══════════════                                  │
│  • Admin can reset warga password                │
│  • Warga can request reset via email             │
└─────────────────────────────────────────────────┘
```

### 2.2 Why Email+Password (Not Phone OTP)

| Factor | Email+Password | Phone OTP |
|--------|---------------|-----------|
| Cost | **Free** | $0.01-0.06/SMS |
| Scale limit | Unlimited | Budget dependent |
| Reliability | 100% | SMS delivery varies |
| Complexity | Simple | Need SMS provider |
| Offline | N/A (one-time) | Need signal for OTP |

**Decision**: Email+Password with format `[nik_suffix]@siwarga.rt05` or real email.

---

## 3. Role-Based Access Control (RBAC)

### 3.1 Role Definitions

```
┌─────────────────────────────────────────────────┐
│                ROLE HIERARCHY                    │
│                                                  │
│  ┌─────────────┐                                │
│  │ super_admin │  Full system access             │
│  │ (Developer) │  Can promote admins             │
│  └──────┬──────┘                                │
│         │                                        │
│  ┌──────▼──────┐                                │
│  │    admin    │  Manage warga, announcements    │
│  │   (RT/RW)  │  Moderate discussions            │
│  └──────┬──────┘                                │
│         │                                        │
│  ┌──────▼──────┐                                │
│  │    warga   │  Standard access                 │
│  │  (Citizen) │  Report, discuss, SOS            │
│  └─────────────┘                                │
└─────────────────────────────────────────────────┘
```

### 3.2 Permission Matrix

| Feature | warga | admin | super_admin |
|---------|-------|-------|-------------|
| View beranda | ✅ | ✅ | ✅ |
| View data warga | ✅ (limited) | ✅ (full) | ✅ (full) |
| Create laporan | ✅ | ✅ | ✅ |
| Update laporan status | ❌ | ✅ | ✅ |
| Trigger SOS | ✅ | ✅ | ✅ |
| Resolve SOS | ❌ | ✅ | ✅ |
| Send diskusi | ✅ | ✅ | ✅ |
| Delete diskusi | Own only | ✅ All | ✅ All |
| Create pengumuman | ❌ | ✅ | ✅ |
| Register warga | ❌ | ✅ | ✅ |
| Deactivate warga | ❌ | ✅ | ✅ |
| Manage keuangan | ❌ | ✅ | ✅ |
| View keuangan | Own only | ✅ All | ✅ All |
| Edit kontrakan | ❌ | ✅ | ✅ |
| Manage UMKM | Own only | ✅ All | ✅ All |
| Buku tamu | ✅ (own) | ✅ All | ✅ All |
| App settings | ❌ | ❌ | ✅ |

### 3.3 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper: Check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper: Check if user is admin
    function isAdmin() {
      return isAuthenticated() && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'super_admin'];
    }
    
    // Helper: Check if user belongs to same RT
    function isSameRT(rtId) {
      return isAuthenticated() && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.rt_id == rtId;
    }
    
    // Helper: Check document ownership
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // USERS collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin();
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // REPORTS collection
    match /reports/{reportId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAdmin() || 
        (isOwner(resource.data.user_id) && resource.data.status == 'pending');
      allow delete: if isAdmin();
    }
    
    // EMERGENCIES collection
    match /emergencies/{emergencyId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isAdmin();
      allow delete: if false; // Never delete emergency logs
    }
    
    // DISCUSSIONS collection  
    match /discussions/{messageId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.user_id);
      allow delete: if isOwner(resource.data.user_id) || isAdmin();
    }
    
    // ANNOUNCEMENTS collection
    match /announcements/{announcementId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin();
      allow update: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // KEUANGAN collection
    match /keuangan/{keuanganId} {
      allow read: if isAuthenticated();
      allow create: if isAdmin() || isOwner(request.resource.data.user_id);
      allow update: if isAdmin();
      allow delete: if false; // Audit trail
    }
    
    // KONTRAKAN, UMKM, BUKU_TAMU, ANAK_YATIM
    match /kontrakan/{docId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
    match /umkm/{docId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.user_id) || isAdmin();
      allow delete: if isAdmin();
    }
    match /buku_tamu/{docId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if isOwner(resource.data.warga_id) || isAdmin();
      allow delete: if isAdmin();
    }
    match /anak_yatim/{docId} {
      allow read: if isAuthenticated();
      allow write: if isAdmin();
    }
  }
}
```

---

## 4. Data Protection

### 4.1 Sensitive Data Handling

| Data | Classification | Protection |
|------|---------------|------------|
| NIK | **HIGHLY SENSITIVE** | Masked in UI (`32xx-xxxx-xxxx-1234`), encrypted at rest |
| No HP | Sensitive | Visible to same RT only |
| Password | Critical | Hashed by Firebase Auth (bcrypt) |
| Alamat | Sensitive | Only visible to authenticated users |
| FCM Token | Internal | Never exposed to other users |

### 4.2 NIK Masking Logic

```dart
String maskNIK(String nik) {
  if (nik.length < 4) return '****';
  return '${'*' * (nik.length - 4)}${nik.substring(nik.length - 4)}';
}
// Input:  "3201234567890123"
// Output: "************0123"
```

### 4.3 Data Encryption

| Layer | Method |
|-------|--------|
| In Transit | TLS 1.3 (Firebase default) |
| At Rest | AES-256 (Firestore default) |
| Local Cache | Encrypted SharedPreferences |
| NIK Field | Application-level encryption before storage |

---

## 5. SOS Anti-Abuse System

> **Problem**: Warga bisa salah tekan atau sengaja iseng tekan tombol SOS.

### 5.1 Prevention Layers

```
Layer 1: UI Confirmation
  └─► "Apakah Anda yakin?" dialog with countdown timer (3 sec)

Layer 2: Category Selection
  └─► Warga HARUS pilih jenis darurat sebelum kirim

Layer 3: Rate Limiting
  └─► Max 3 SOS per hour per user
  └─► Cooldown 5 minutes between SOS

Layer 4: Logging
  └─► Semua SOS tercatat (siapa, kapan, jenis)
  └─► Admin bisa review history

Layer 5: Admin Action
  └─► Admin bisa "mute" user yang abuse
  └─► Warning system: 1st = warning, 2nd = temp mute, 3rd = report
```

---

## 6. Threat Model

| Threat | Risk | Mitigation |
|--------|------|------------|
| Unauthorized access | High | Firebase Auth + Security Rules |
| SOS false alarm | Medium | Multi-layer confirmation + rate limiting |
| Data leak (NIK) | High | Masking + encryption |
| Spam in diskusi | Medium | Admin moderation + rate limiting |
| Account takeover | Medium | Password policies + admin reset |
| Insecure APK | Low | ProGuard obfuscation on release build |
| Man-in-middle | Low | TLS enforced by Firebase |
| Brute force login | Low | Firebase built-in rate limiting |

---

## 7. Privacy Policy Requirements

Data yang dikumpulkan dan tujuannya (untuk transparansi ke warga):

| Data | Tujuan | Retensi |
|------|--------|---------|
| Nama | Identifikasi warga | Selama aktif |
| NIK | Verifikasi identitas | Selama aktif, encrypted |
| No HP | Kontak darurat | Selama aktif |
| Alamat/No Rumah | Lokasi darurat & data RT | Selama aktif |
| Chat/Diskusi | Komunikasi warga | 6 bulan |
| Laporan | Dokumentasi masalah | 1 tahun |
| SOS Log | Keamanan & audit | Permanent |

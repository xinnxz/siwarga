# 🔌 04 — API & Service Layer Design

> **Version**: 1.0.0 | **Updated**: 2026-04-28

---

## 1. Service Layer Overview

Setiap fitur memiliki **Service** yang menangani business logic dan komunikasi dengan Firebase.

```
┌─────────────────────────────────────────────────┐
│               SERVICE LAYER MAP                  │
│                                                  │
│  ┌─────────────┐  ┌─────────────────────────┐   │
│  │ AuthService │  │ NotificationService     │   │
│  │             │  │                         │   │
│  │ • login()   │  │ • initFCM()             │   │
│  │ • logout()  │  │ • sendSOSNotification() │   │
│  │ • register()│  │ • subscribeToTopic()    │   │
│  └─────────────┘  └─────────────────────────┘   │
│                                                  │
│  ┌─────────────┐  ┌─────────────────────────┐   │
│  │ UserService │  │ EmergencyService        │   │
│  │             │  │                         │   │
│  │ • getUser() │  │ • triggerSOS()          │   │
│  │ • getAll()  │  │ • resolveEmergency()    │   │
│  │ • update()  │  │ • getActiveEmergency()  │   │
│  └─────────────┘  └─────────────────────────┘   │
│                                                  │
│  ┌─────────────┐  ┌─────────────────────────┐   │
│  │ReportService│  │ DiscussionService       │   │
│  │             │  │                         │   │
│  │ • create()  │  │ • sendMessage()         │   │
│  │ • getAll()  │  │ • getMessages()         │   │
│  │ • update()  │  │ • deleteMessage()       │   │
│  └─────────────┘  └─────────────────────────┘   │
│                                                  │
│  ┌──────────────────┐  ┌────────────────────┐   │
│  │AnnouncementSvc   │  │ KeuanganService    │   │
│  │                  │  │                    │   │
│  │ • create()       │  │ • recordPayment()  │   │
│  │ • getAll()       │  │ • getHistory()     │   │
│  │ • pin/unpin()    │  │ • getArrears()     │   │
│  └──────────────────┘  └────────────────────┘   │
└─────────────────────────────────────────────────┘
```

---

## 2. Repository Pattern

### 2.1 Abstract Repository Interface (Domain Layer)

```dart
// domain/repositories/user_repository.dart

abstract class UserRepository {
  /// Get user by UID
  Future<AppResult<UserEntity>> getUserById(String uid);
  
  /// Get all users in same RT
  Future<AppResult<List<UserEntity>>> getUsersByRT(String rtId);
  
  /// Stream user data (realtime)
  Stream<UserEntity?> watchUser(String uid);
  
  /// Create new user (admin only)
  Future<AppResult<void>> createUser(UserEntity user);
  
  /// Update user profile
  Future<AppResult<void>> updateUser(String uid, Map<String, dynamic> data);
  
  /// Deactivate user (admin only)
  Future<AppResult<void>> deactivateUser(String uid);
  
  /// Update FCM token
  Future<AppResult<void>> updateFCMToken(String uid, String token);
}
```

### 2.2 Firebase Implementation (Infrastructure Layer)

```dart
// infrastructure/repositories/firebase_user_repository.dart

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore;
  
  FirebaseUserRepository(this._firestore);
  
  @override
  Future<AppResult<UserEntity>> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return Failure(AppError.notFound('User not found'));
      return Success(UserEntity.fromFirestore(doc));
    } on FirebaseException catch (e) {
      return Failure(AppError.server(e.message ?? 'Firebase error'));
    } catch (e) {
      return Failure(AppError.unknown(e.toString()));
    }
  }
  
  @override
  Stream<UserEntity?> watchUser(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserEntity.fromFirestore(doc) : null);
  }
  
  // ... other implementations
}
```

---

## 3. Service Contracts

### 3.1 AuthService

```dart
abstract class AuthService {
  /// Login with email and password
  /// Returns: UserEntity on success
  /// Throws: AuthException on failure
  Future<AppResult<UserEntity>> login(String email, String password);
  
  /// Register new user (admin only)
  /// Creates Firebase Auth user + Firestore profile
  Future<AppResult<UserEntity>> registerUser({
    required String nama,
    required String email,
    required String password,
    required String nik,
    required String noHp,
    required String nomorRumah,
    required String rtId,
    String role = 'warga',
  });
  
  /// Logout current user
  /// Clears FCM token and local session
  Future<AppResult<void>> logout();
  
  /// Get current authenticated user
  UserEntity? get currentUser;
  
  /// Stream auth state changes
  Stream<UserEntity?> get authStateChanges;
  
  /// Reset password (admin or self)
  Future<AppResult<void>> resetPassword(String email);
  
  /// Change password
  Future<AppResult<void>> changePassword(String oldPass, String newPass);
}
```

### 3.2 EmergencyService (SOS)

```dart
abstract class EmergencyService {
  /// Trigger SOS alert
  /// 1. Validates rate limit
  /// 2. Creates emergency document
  /// 3. Sends FCM to all devices in RT
  /// 4. Returns emergency ID
  Future<AppResult<String>> triggerSOS({
    required String userId,
    required String jenisdarurat, // maling, kdrt, kebakaran, etc.
    String? deskripsi,
  });
  
  /// Resolve/deactivate an emergency (admin only)
  Future<AppResult<void>> resolveEmergency(String emergencyId, String adminId);
  
  /// Get active emergencies for RT
  Stream<List<EmergencyEntity>> watchActiveEmergencies(String rtId);
  
  /// Get emergency history
  Future<AppResult<List<EmergencyEntity>>> getEmergencyHistory({
    required String rtId,
    int limit = 50,
  });
  
  /// Check if user can trigger SOS (rate limiting)
  Future<bool> canTriggerSOS(String userId);
}
```

### 3.3 ReportService

```dart
abstract class ReportService {
  /// Create a new report
  Future<AppResult<String>> createReport({
    required String userId,
    required String judul,
    required String isiLaporan,
    required String kategori,
    List<String>? fotoUrls,
  });
  
  /// Get all reports for RT (with pagination)
  Future<AppResult<List<ReportEntity>>> getReports({
    required String rtId,
    String? kategori,
    String? status,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  });
  
  /// Update report status (admin only)
  Future<AppResult<void>> updateReportStatus({
    required String reportId,
    required String status,
    String? adminResponse,
  });
  
  /// Stream reports realtime
  Stream<List<ReportEntity>> watchReports(String rtId);
}
```

### 3.4 DiscussionService

```dart
abstract class DiscussionService {
  /// Send a message
  Future<AppResult<void>> sendMessage({
    required String userId,
    required String pesan,
    String tipe = 'text',
    String? mediaUrl,
    String? replyTo,
  });
  
  /// Stream messages (realtime chat)
  Stream<List<DiscussionEntity>> watchMessages({
    required String rtId,
    int limit = 50,
  });
  
  /// Delete message (own or admin)
  Future<AppResult<void>> deleteMessage(String messageId);
  
  /// Load older messages (pagination)
  Future<AppResult<List<DiscussionEntity>>> loadMoreMessages({
    required String rtId,
    required DocumentSnapshot lastDoc,
    int limit = 20,
  });
}
```

### 3.5 NotificationService

```dart
abstract class NotificationService {
  /// Initialize FCM and request permissions
  Future<void> initialize();
  
  /// Get current FCM token
  Future<String?> getToken();
  
  /// Subscribe to RT topic (for broadcast notifications)
  Future<void> subscribeToRT(String rtId);
  
  /// Handle incoming notification
  void onNotificationReceived(RemoteMessage message);
  
  /// Send SOS notification to all devices (via Cloud Function)
  Future<AppResult<void>> sendSOSNotification({
    required String rtId,
    required String namaPelapor,
    required String nomorRumah,
    required String jenisDarurat,
  });
  
  /// Play siren sound
  Future<void> playSiren();
  
  /// Stop siren sound
  Future<void> stopSiren();
}
```

---

## 4. Riverpod Provider Structure

```dart
// ── AUTH PROVIDERS ──
final firebaseAuthProvider = Provider<FirebaseAuth>(...);
final authServiceProvider = Provider<AuthService>(...);
final authStateProvider = StreamProvider<UserEntity?>(...);
final currentUserProvider = Provider<UserEntity?>(...);

// ── USER PROVIDERS ──
final userRepositoryProvider = Provider<UserRepository>(...);
final allUsersProvider = StreamProvider<List<UserEntity>>(...);
final userByIdProvider = FutureProvider.family<UserEntity, String>(...);

// ── REPORT PROVIDERS ──
final reportServiceProvider = Provider<ReportService>(...);
final reportsProvider = StreamProvider<List<ReportEntity>>(...);
final createReportProvider = FutureProvider.family(...);

// ── EMERGENCY PROVIDERS ──
final emergencyServiceProvider = Provider<EmergencyService>(...);
final activeEmergenciesProvider = StreamProvider<List<EmergencyEntity>>(...);
final canTriggerSOSProvider = FutureProvider<bool>(...);

// ── DISCUSSION PROVIDERS ──
final discussionServiceProvider = Provider<DiscussionService>(...);
final messagesProvider = StreamProvider<List<DiscussionEntity>>(...);

// ── ANNOUNCEMENT PROVIDERS ──
final announcementServiceProvider = Provider<AnnouncementService>(...);
final announcementsProvider = StreamProvider<List<AnnouncementEntity>>(...);

// ── NOTIFICATION PROVIDERS ──
final notificationServiceProvider = Provider<NotificationService>(...);
```

---

## 5. Error Handling Contract

### 5.1 AppError Class

```dart
class AppError {
  final AppErrorType type;
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppError({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
  });
  
  factory AppError.network([String? msg]) => AppError(
    type: AppErrorType.network,
    message: msg ?? 'Tidak ada koneksi internet',
  );
  
  factory AppError.auth([String? msg]) => AppError(
    type: AppErrorType.auth,
    message: msg ?? 'Gagal autentikasi',
  );
  
  factory AppError.permission([String? msg]) => AppError(
    type: AppErrorType.permission,
    message: msg ?? 'Anda tidak memiliki akses',
  );
  
  factory AppError.notFound([String? msg]) => AppError(
    type: AppErrorType.notFound,
    message: msg ?? 'Data tidak ditemukan',
  );
  
  factory AppError.validation(String msg) => AppError(
    type: AppErrorType.validation,
    message: msg,
  );
  
  factory AppError.server([String? msg]) => AppError(
    type: AppErrorType.server,
    message: msg ?? 'Terjadi kesalahan server',
  );
  
  factory AppError.unknown([String? msg]) => AppError(
    type: AppErrorType.unknown,
    message: msg ?? 'Terjadi kesalahan',
  );
}
```

### 5.2 Error Display in UI

| Error Type | UI Response |
|-----------|-------------|
| `network` | Snackbar "Tidak ada koneksi" + retry button |
| `auth` | Redirect ke login screen |
| `permission` | Dialog "Anda tidak memiliki akses" |
| `notFound` | Empty state widget |
| `validation` | Inline form error messages |
| `server` | Snackbar with error message + log |
| `unknown` | Generic error snackbar + crash report |

---

## 6. Pagination Strategy

All list queries use **cursor-based pagination** (Firestore best practice):

```dart
class PaginatedResult<T> {
  final List<T> items;
  final bool hasMore;
  final DocumentSnapshot? lastDocument; // cursor for next page
  
  const PaginatedResult({
    required this.items,
    required this.hasMore,
    this.lastDocument,
  });
}

// Usage:
Future<PaginatedResult<ReportEntity>> getReports({
  required String rtId,
  int pageSize = 20,
  DocumentSnapshot? startAfter,
}) async {
  var query = _firestore
      .collection('reports')
      .where('rt_id', isEqualTo: rtId)
      .orderBy('created_at', descending: true)
      .limit(pageSize + 1); // +1 to check hasMore
  
  if (startAfter != null) {
    query = query.startAfterDocument(startAfter);
  }
  
  final snapshot = await query.get();
  final hasMore = snapshot.docs.length > pageSize;
  final docs = hasMore ? snapshot.docs.take(pageSize).toList() : snapshot.docs;
  
  return PaginatedResult(
    items: docs.map((d) => ReportEntity.fromFirestore(d)).toList(),
    hasMore: hasMore,
    lastDocument: docs.isNotEmpty ? docs.last : null,
  );
}
```

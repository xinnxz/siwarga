# Contributing to SiWarga

Terima kasih telah berkontribusi ke SiWarga! 🎉

## 📋 Development Workflow

### 1. Branch dari `develop`
```bash
git checkout develop
git pull origin develop
git checkout -b feature/nama-fitur
```

### 2. Naming Convention untuk Branch
| Tipe | Format | Contoh |
|------|--------|--------|
| Feature | `feature/deskripsi-singkat` | `feature/sos-button` |
| Bug fix | `fix/deskripsi-bug` | `fix/login-crash` |
| Docs | `docs/deskripsi` | `docs/api-documentation` |
| Chore | `chore/deskripsi` | `chore/update-deps` |

### 3. Commit Messages
Format: `type(scope): description`

```
feat(auth): implement login screen
fix(sos): resolve siren playback issue
docs(readme): update installation steps
test(reports): add unit tests for validation
```

### 4. Pull Request
- PR ke branch `develop`
- Deskripsi jelas tentang apa yang berubah
- Pastikan semua tests pass
- Minimal 1 reviewer

## 🧪 Testing

```bash
# Wajib sebelum PR
flutter analyze
flutter test
```

## 📐 Coding Standards

Lihat [Project Structure & Coding Standards](docs/architecture/06-project-structure.md) untuk detail lengkap.

### Quick Rules:
1. File names: `snake_case.dart`
2. Class names: `PascalCase`
3. Variables: `camelCase`
4. Max line length: 80 characters
5. Always use `const` constructors when possible
6. Always add type annotations
7. Use `final` for immutable variables
8. No `print()` statements — use logger

## 🔒 Security

- JANGAN commit API keys, secrets, atau credentials
- Gunakan `.env` atau environment variables
- NIK harus selalu di-mask di UI
- Pastikan Firestore rules sudah benar sebelum deploy

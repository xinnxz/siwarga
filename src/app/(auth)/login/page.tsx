"use client";

import { useState } from "react";
import Link from "next/link";
import styles from "../auth.module.css";

export default function LoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    if (!username || !password) {
      setError("Username dan password wajib diisi");
      return;
    }
    setError("");
    setLoading(true);
    // TODO Phase 3 Plan 03-01: Supabase Auth integration
    await new Promise((r) => setTimeout(r, 1000));
    setLoading(false);
    setError("Fitur login sedang diintegrasikan dengan Supabase Auth.");
  }

  return (
    <div className={styles.authPage}>
      {/* Brand */}
      <div className={styles.brand}>
        <div className={styles.brandLogo}>🏡</div>
        <h1 className={styles.brandName}>SiWarga</h1>
        <p className={styles.brandTagline}>Smart Community Platform · RT 05</p>
      </div>

      {/* Card */}
      <div className={styles.authCard}>
        <h2 className={styles.authTitle}>Selamat datang</h2>
        <p className={styles.authSubtitle}>Masuk ke akun SiWarga kamu</p>

        <form className={styles.form} onSubmit={handleLogin} noValidate>
          {/* Username */}
          <div className={styles.formGroup}>
            <label htmlFor="username" className={styles.formLabel}>
              Username / No. Rumah
            </label>
            <div className={styles.inputWrapper}>
              <span className={styles.inputIcon}>👤</span>
              <input
                id="username"
                type="text"
                className={`input ${styles.inputWithIcon}`}
                placeholder="Contoh: warga05"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                autoComplete="username"
                autoCapitalize="none"
              />
            </div>
          </div>

          {/* Password */}
          <div className={styles.formGroup}>
            <label htmlFor="password" className={styles.formLabel}>
              Password
            </label>
            <div className={styles.inputWrapper}>
              <span className={styles.inputIcon}>🔒</span>
              <input
                id="password"
                type={showPassword ? "text" : "password"}
                className={`input ${styles.inputWithIcon}`}
                placeholder="Password kamu"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                autoComplete="current-password"
              />
              <button
                type="button"
                className={styles.passwordToggle}
                onClick={() => setShowPassword(!showPassword)}
                aria-label={showPassword ? "Sembunyikan password" : "Tampilkan password"}
              >
                {showPassword ? "🙈" : "👁️"}
              </button>
            </div>
          </div>

          {/* Error */}
          {error && (
            <p className={styles.errorMsg} role="alert">
              ⚠️ {error}
            </p>
          )}

          {/* Submit */}
          <button
            type="submit"
            className={styles.submitBtn}
            disabled={loading}
            id="btn-login"
          >
            {loading ? "⏳ Masuk..." : "Masuk →"}
          </button>
        </form>

        {/* Register link */}
        <p className={styles.authSwitch}>
          Belum punya akun?{" "}
          <Link href="/register">Daftar dengan kode undangan</Link>
        </p>
      </div>
    </div>
  );
}

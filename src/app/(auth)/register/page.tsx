"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import styles from "../auth.module.css";

type Step = 1 | 2 | 3;

interface FormData {
  inviteCode: string;
  name: string;
  houseNumber: string;
  phone: string;
  username: string;
  password: string;
  confirmPassword: string;
}

const INITIAL: FormData = {
  inviteCode: "",
  name: "",
  houseNumber: "",
  phone: "",
  username: "",
  password: "",
  confirmPassword: "",
};

const STEP_LABELS = ["Kode Undangan", "Data Diri", "Akun"];

export default function RegisterPage() {
  const router = useRouter();
  const [step, setStep] = useState<Step>(1);
  const [form, setForm] = useState<FormData>(INITIAL);
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  function update(field: keyof FormData, value: string) {
    setForm((prev) => ({ ...prev, [field]: value }));
    setError("");
  }

  async function handleStep1() {
    if (form.inviteCode.length !== 5) {
      setError("Kode undangan harus terdiri dari 5 karakter.");
      return;
    }
    setLoading(true);
    // TODO: validate invite code via API
    await new Promise((r) => setTimeout(r, 800));
    setLoading(false);
    setStep(2);
  }

  async function handleStep2() {
    if (!form.name || !form.houseNumber) {
      setError("Nama lengkap dan nomor rumah wajib diisi");
      return;
    }
    setLoading(true);
    // TODO: verify house number exists in residents table
    await new Promise((r) => setTimeout(r, 800));
    setLoading(false);
    setStep(3);
  }

  async function handleStep3() {
    if (!form.username || !form.password) {
      setError("Username dan password wajib diisi");
      return;
    }
    if (form.password !== form.confirmPassword) {
      setError("Konfirmasi password tidak cocok");
      return;
    }
    if (form.password.length < 8) {
      setError("Password minimal 8 karakter");
      return;
    }
    setLoading(true);
    try {
      const res = await fetch("/api/auth/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      const data = await res.json();
      
      if (!res.ok) {
        setError(data.error || "Gagal mendaftar. Coba lagi.");
        return;
      }

      // Sukses
      router.push("/login?registered=true");
    } catch (err) {
      setError("Terjadi kesalahan sistem.");
    } finally {
      setLoading(false);
    }
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    if (step === 1) handleStep1();
    else if (step === 2) handleStep2();
    else handleStep3();
  }

  return (
    <div className={styles.authPage}>
      {/* Brand */}
      <div className={styles.brand}>
        <div className={styles.brandLogo}>🏡</div>
        <h1 className={styles.brandName}>SiWarga</h1>
        <p className={styles.brandTagline}>Daftar sebagai warga RT 05</p>
      </div>

      {/* Card */}
      <div className={styles.authCard}>
        {/* Step indicator */}
        <div className={styles.steps} role="progressbar" aria-valuenow={step} aria-valuemax={3}>
          {STEP_LABELS.map((label, i) => {
            const n = (i + 1) as Step;
            return (
              <div key={label} style={{ display: "contents" }}>
                <div
                  className={`${styles.step} ${n === step ? styles.active : ""} ${n < step ? styles.done : ""}`}
                  aria-label={`Langkah ${n}: ${label}`}
                >
                  {n < step ? "✓" : n}
                </div>
                {i < STEP_LABELS.length - 1 && (
                  <div className={`${styles.stepConnector} ${n < step ? styles.done : ""}`} />
                )}
              </div>
            );
          })}
        </div>

        {/* Step titles */}
        {step === 1 && (
          <>
            <h2 className={styles.authTitle}>Kode Undangan</h2>
            <p className={styles.authSubtitle}>Masukkan kode yang diberikan pengurus RT</p>
          </>
        )}
        {step === 2 && (
          <>
            <h2 className={styles.authTitle}>Data Diri</h2>
            <p className={styles.authSubtitle}>Pastikan data sesuai dengan data warga RT</p>
          </>
        )}
        {step === 3 && (
          <>
            <h2 className={styles.authTitle}>Buat Akun</h2>
            <p className={styles.authSubtitle}>Username dan password untuk login</p>
          </>
        )}

        <form className={styles.form} onSubmit={handleSubmit} noValidate>
          {/* ── Step 1: Invite Code ── */}
          {step === 1 && (
            <>
              <div className={styles.formGroup}>
                <label htmlFor="inviteCode" className={styles.formLabel}>
                  Kode Undangan
                </label>
                <input
                  id="inviteCode"
                  type="text"
                  className={`input ${styles.inviteInput}`}
                  placeholder="RT05X"
                  value={form.inviteCode}
                  onChange={(e) => update("inviteCode", e.target.value.toUpperCase())}
                  maxLength={5}
                  autoCapitalize="characters"
                  autoComplete="off"
                />
              </div>
              <div className={styles.infoBox}>
                <strong>💬 Cara mendapatkan kode:</strong>
                <br />
                Minta kode undangan kepada Ketua RT atau Pengurus melalui grup WhatsApp RT 05.
              </div>
            </>
          )}

          {/* ── Step 2: Personal Data ── */}
          {step === 2 && (
            <>
              <div className={styles.formGroup}>
                <label htmlFor="name" className={styles.formLabel}>
                  Nama Lengkap
                </label>
                <div className={styles.inputWrapper}>
                  <span className={styles.inputIcon}>👤</span>
                  <input
                    id="name"
                    type="text"
                    className={`input ${styles.inputWithIcon}`}
                    placeholder="Sesuai KTP"
                    value={form.name}
                    onChange={(e) => update("name", e.target.value)}
                    autoComplete="name"
                  />
                </div>
              </div>
              <div className={styles.formGroup}>
                <label htmlFor="houseNumber" className={styles.formLabel}>
                  Nomor Rumah
                </label>
                <div className={styles.inputWrapper}>
                  <span className={styles.inputIcon}>🏠</span>
                  <input
                    id="houseNumber"
                    type="text"
                    className={`input ${styles.inputWithIcon}`}
                    placeholder="Contoh: 12A"
                    value={form.houseNumber}
                    onChange={(e) => update("houseNumber", e.target.value)}
                  />
                </div>
              </div>
              <div className={styles.formGroup}>
                <label htmlFor="phone" className={styles.formLabel}>
                  No. HP (opsional)
                </label>
                <div className={styles.inputWrapper}>
                  <span className={styles.inputIcon}>📱</span>
                  <input
                    id="phone"
                    type="tel"
                    className={`input ${styles.inputWithIcon}`}
                    placeholder="08xxxxxxxxxx"
                    value={form.phone}
                    onChange={(e) => update("phone", e.target.value)}
                    autoComplete="tel"
                  />
                </div>
              </div>
              <div className={styles.infoBox}>
                <strong>⚠️ Verifikasi diperlukan:</strong>
                <br />
                Nomor rumah akan dicocokkan dengan data warga terdaftar.
              </div>
            </>
          )}

          {/* ── Step 3: Account ── */}
          {step === 3 && (
            <>
              <div className={styles.formGroup}>
                <label htmlFor="reg-username" className={styles.formLabel}>
                  Username
                </label>
                <div className={styles.inputWrapper}>
                  <span className={styles.inputIcon}>🪪</span>
                  <input
                    id="reg-username"
                    type="text"
                    className={`input ${styles.inputWithIcon}`}
                    placeholder="Contoh: budi05"
                    value={form.username}
                    onChange={(e) => update("username", e.target.value.toLowerCase())}
                    autoCapitalize="none"
                    autoComplete="username"
                  />
                </div>
              </div>
              <div className={styles.formGroup}>
                <label htmlFor="reg-password" className={styles.formLabel}>
                  Password
                </label>
                <div className={styles.inputWrapper}>
                  <span className={styles.inputIcon}>🔒</span>
                  <input
                    id="reg-password"
                    type={showPassword ? "text" : "password"}
                    className={`input ${styles.inputWithIcon}`}
                    placeholder="Min. 8 karakter"
                    value={form.password}
                    onChange={(e) => update("password", e.target.value)}
                    autoComplete="new-password"
                  />
                  <button
                    type="button"
                    className={styles.passwordToggle}
                    onClick={() => setShowPassword(!showPassword)}
                    aria-label="Toggle password"
                  >
                    {showPassword ? "🙈" : "👁️"}
                  </button>
                </div>
              </div>
              <div className={styles.formGroup}>
                <label htmlFor="confirm-password" className={styles.formLabel}>
                  Konfirmasi Password
                </label>
                <div className={styles.inputWrapper}>
                  <span className={styles.inputIcon}>🔑</span>
                  <input
                    id="confirm-password"
                    type="password"
                    className={`input ${styles.inputWithIcon}`}
                    placeholder="Ulangi password"
                    value={form.confirmPassword}
                    onChange={(e) => update("confirmPassword", e.target.value)}
                    autoComplete="new-password"
                  />
                </div>
              </div>
            </>
          )}

          {/* Error */}
          {error && (
            <p className={styles.errorMsg} role="alert">
              ⚠️ {error}
            </p>
          )}

          {/* Buttons */}
          <div style={{ display: "flex", gap: "var(--space-3)", marginTop: "var(--space-2)" }}>
            {step > 1 && (
              <button
                type="button"
                className="btn btn--ghost btn--full"
                onClick={() => setStep((s) => (s - 1) as Step)}
                disabled={loading}
                style={{ flex: "0 0 auto", width: "auto", padding: "var(--space-3) var(--space-4)" }}
              >
                ← Kembali
              </button>
            )}
            <button
              type="submit"
              className={styles.submitBtn}
              disabled={loading}
              id={`btn-register-step-${step}`}
            >
              {loading
                ? "⏳ Memeriksa..."
                : step < 3
                  ? "Lanjut →"
                  : "🎉 Daftar Sekarang"}
            </button>
          </div>
        </form>

        <p className={styles.authSwitch}>
          Sudah punya akun?{" "}
          <Link href="/login">Masuk di sini</Link>
        </p>
      </div>
    </div>
  );
}

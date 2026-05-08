import type { Metadata } from "next";
import styles from "./dashboard.module.css";

export const metadata: Metadata = {
  title: "Dashboard — SiWarga",
};

const menuItems = [
  { icon: "📢", label: "Pengumuman", href: "/pengumuman" },
  { icon: "🚨", label: "SOS Darurat", href: "/sos" },
  { icon: "💬", label: "Diskusi", href: "/chat" },
  { icon: "📝", label: "Laporan", href: "/laporan" },
  { icon: "💰", label: "Kas RT", href: "/kas" },
  { icon: "👨‍👩‍👧", label: "Data Warga", href: "/warga" },
  { icon: "🏠", label: "Kontrakan", href: "/kontrakan" },
  { icon: "🛍️", label: "UMKM", href: "/umkm" },
  { icon: "📋", label: "Buku Tamu", href: "/tamu" },
  { icon: "🌙", label: "Ronda", href: "/ronda" },
  { icon: "📌", label: "Info RT", href: "/info-rt" },
  { icon: "⚙️", label: "Pengaturan", href: "/settings" },
];

const stats = [
  { label: "Total Warga", value: "48 KK", icon: "👨‍👩‍👧", color: "var(--color-primary)" },
  { label: "Laporan Aktif", value: "3", icon: "📝", color: "var(--color-warning)" },
  { label: "SOS Bulan Ini", value: "0", icon: "🚨", color: "var(--color-danger)" },
];

export default function DashboardPage() {
  return (
    <div className={styles.page}>
      {/* Header */}
      <header className="header">
        <div className="header__top">
          <div>
            <p className="header__greeting">Selamat datang di</p>
            <h1 className="header__name">SiWarga RT 05</h1>
            <p className="header__role">Sinar Giri Harja 🏡</p>
          </div>
          <div className="header__avatar">👤</div>
        </div>
      </header>

      <main>
        {/* Stats */}
        <section className={styles.statsSection}>
          <div className={styles.statsGrid}>
            {stats.map((stat) => (
              <div key={stat.label} className={`card card--solid ${styles.statCard}`}>
                <span className={styles.statIcon}>{stat.icon}</span>
                <span className={styles.statValue} style={{ color: stat.color }}>
                  {stat.value}
                </span>
                <span className={styles.statLabel}>{stat.label}</span>
              </div>
            ))}
          </div>
        </section>

        {/* SOS Button */}
        <section className={styles.sosSection}>
          <button className={styles.sosButton} aria-label="Tombol SOS Darurat">
            <span className={styles.sosIcon}>🚨</span>
            <span className={styles.sosText}>SOS DARURAT</span>
            <span className={styles.sosSubtext}>Tekan untuk lapor darurat</span>
          </button>
        </section>

        {/* Quick Actions */}
        <section>
          <p className="section-label">Menu Utama</p>
          <div className="menu-grid">
            {menuItems.map((item) => (
              <a key={item.label} href={item.href} className="menu-item">
                <div className="menu-item__icon">{item.icon}</div>
                <span className="menu-item__label">{item.label}</span>
              </a>
            ))}
          </div>
        </section>

        {/* Pengumuman Terbaru */}
        <section className={styles.announcementsSection}>
          <p className="section-label">Pengumuman Terbaru</p>
          <div className="content-area" style={{ paddingTop: 0 }}>
            <div className={`card card--accent-left animate-fade-in-up`}>
              <div className={styles.announcementItem}>
                <div>
                  <p className={styles.announcementTitle}>Kerja Bakti RT 05</p>
                  <p className={styles.announcementDate}>Sabtu, 10 Mei 2026 · 07.00 WIB</p>
                  <p className={styles.announcementBody}>
                    Seluruh warga diharap hadir untuk kerja bakti membersihkan selokan dan taman
                    lingkungan RT 05.
                  </p>
                </div>
                <span className="badge badge--primary">Baru</span>
              </div>
            </div>
            <div className={`card card--accent-left animate-fade-in-up`} style={{ animationDelay: "50ms" }}>
              <div className={styles.announcementItem}>
                <div>
                  <p className={styles.announcementTitle}>Iuran Bulanan Mei 2026</p>
                  <p className={styles.announcementDate}>Senin, 5 Mei 2026</p>
                  <p className={styles.announcementBody}>
                    Iuran bulanan Mei sudah dapat dibayarkan ke Bendahara RT.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>

      {/* Bottom Navigation */}
      <nav className="bottom-nav">
        <button className="nav-item active">
          <span className="nav-item__icon">🏠</span>
          <span>Beranda</span>
        </button>
        <button className="nav-item">
          <span className="nav-item__icon">💬</span>
          <span>Diskusi</span>
        </button>
        <button className="nav-item">
          <span className="nav-item__icon">📝</span>
          <span>Laporan</span>
        </button>
        <button className="nav-item">
          <span className="nav-item__icon">👤</span>
          <span>Profil</span>
        </button>
      </nav>
    </div>
  );
}

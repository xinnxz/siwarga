import type { Metadata } from "next";
import styles from "./dashboard.module.css";

export const metadata: Metadata = {
  title: "Dashboard — SiWarga",
};

const menuItems = [
  { iconClass: "bi bi-people-fill", colorClass: styles.textPrimary, label: "Warga", href: "/warga" },
  { iconClass: "bi bi-house-check-fill", colorClass: styles.textInfo, label: "Kontrakan", href: "/kontrakan" },
  { iconClass: "bi bi-info-circle-fill", colorClass: styles.textWarning, label: "Info RT", href: "/info-rt" },
  { iconClass: "bi bi-heart-fill", colorClass: styles.textDanger, label: "Yatim", href: "/yatim" },
  { iconClass: "bi bi-journal-bookmark-fill", colorClass: styles.textSuccess, label: "Buku Tamu", href: "/tamu" },
  { iconClass: "bi bi-wallet2", colorClass: styles.textPrimary, label: "Uang Kematian", href: "/uang" },
  { iconClass: "bi bi-shop", colorClass: styles.textSuccess, label: "UMKM", href: "/umkm" },
  { iconClass: "bi bi-moon-stars-fill", colorClass: styles.textSecondary, label: "Ronda", href: "/ronda" },
];

export default function DashboardPage() {
  return (
    <div className={styles.page}>
      {/* Header */}
      <header className="header">
        <div className="header__top">
          <div>
            <div className="header__greeting">Sistem Informasi</div>
            <div className="header__name">RT 05 DIGITAL</div>
            <div className="header__greeting" style={{ marginTop: '0.5rem', textTransform: 'none' }}>Bapak Luthfi</div>
            <div className="header__role" style={{ marginTop: '0.2rem' }}>Warga</div>
          </div>
          <div className="header__avatar" style={{ background: 'transparent' }}>
             <i className="bi bi-person-circle" style={{fontSize: '3rem', opacity: 0.9}}></i>
          </div>
        </div>
      </header>

      <main style={{ paddingBottom: '5rem' }}>
        {/* Main Menu */}
        <section>
          <div className={styles.menuLabel}>Menu Utama</div>
          <div className="menu-grid">
            {menuItems.map((item) => (
              <a key={item.label} href={item.href} className="menu-item" style={{textDecoration: 'none'}}>
                <div className="menu-item__icon">
                  <i className={`${item.iconClass} ${item.colorClass}`}></i>
                </div>
                <span className="menu-item__label" style={{fontSize: '0.7rem', color: '#555', fontWeight: 500, textAlign: 'center'}}>{item.label}</span>
              </a>
            ))}
          </div>
        </section>

        {/* Pengumuman Terbaru */}
        <section className={styles.announcementsSection}>
           <div className={styles.sectionTitleContainer}>
              <h2 className={styles.sectionTitle}>PENGUMUMAN TERKINI</h2>
           </div>
           
           <div className={styles.announcementItem}>
              <div style={{flex: 1}}>
                <span className={styles.announcementTitle}>Kerja Bakti RT 05</span>
                <span className={styles.announcementDate}>Sabtu, 10 Mei 2026 · 07.00 WIB</span>
                <span className={styles.announcementBody}>
                  Seluruh warga diharap hadir untuk kerja bakti membersihkan selokan dan taman lingkungan RT 05.
                </span>
              </div>
           </div>

           <div className={styles.announcementItem}>
              <div style={{flex: 1}}>
                <span className={styles.announcementTitle}>Iuran Bulanan Mei 2026</span>
                <span className={styles.announcementDate}>Senin, 5 Mei 2026</span>
                <span className={styles.announcementBody}>
                  Iuran bulanan Mei sudah dapat dibayarkan ke Bendahara RT.
                </span>
              </div>
           </div>
        </section>
      </main>

      {/* Bottom Navigation */}
      <nav className="bottom-nav">
        <button className="nav-item active">
          <i className="bi bi-house-door-fill" style={{fontSize: '1.2rem', marginBottom: '4px'}}></i>
          <span style={{fontSize: '0.65rem', fontWeight: 500}}>Home</span>
        </button>
        <button className="nav-item">
          <i className="bi bi-megaphone-fill" style={{fontSize: '1.2rem', marginBottom: '4px'}}></i>
          <span style={{fontSize: '0.65rem', fontWeight: 500}}>Lapor</span>
        </button>
        <button className="nav-item">
          <i className="bi bi-exclamation-triangle-fill" style={{fontSize: '1.2rem', marginBottom: '4px', color: '#c62828'}}></i>
          <span style={{fontSize: '0.65rem', fontWeight: 500, color: '#c62828'}}>SOS</span>
        </button>
        <button className="nav-item">
          <i className="bi bi-chat-dots-fill" style={{fontSize: '1.2rem', marginBottom: '4px'}}></i>
          <span style={{fontSize: '0.65rem', fontWeight: 500}}>Diskusi</span>
        </button>
        <button className="nav-item">
          <i className="bi bi-person-bounding-box" style={{fontSize: '1.2rem', marginBottom: '4px'}}></i>
          <span style={{fontSize: '0.65rem', fontWeight: 500}}>Tentang</span>
        </button>
      </nav>
    </div>
  );
}

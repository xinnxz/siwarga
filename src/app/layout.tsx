import type { Metadata, Viewport } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "SiWarga — Smart Community Platform",
  description:
    "Platform manajemen komunitas RT/RW modern. SOS darurat, diskusi real-time, laporan warga, dan pengelolaan data dalam satu aplikasi.",
  keywords: ["siwarga", "RT", "RW", "komunitas", "smart community", "PWA"],
  authors: [{ name: "SiWarga Team" }],
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  themeColor: "#4f46e5",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="id" suppressHydrationWarning>
      <head>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" />
      </head>
      <body>
        <div className="app-shell">{children}</div>
      </body>
    </html>
  );
}

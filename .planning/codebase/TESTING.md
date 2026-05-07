# Strategi Pengujian - RT 05 Digital

## Pengujian Manual
Saat ini pengujian dilakukan secara manual oleh pengembang melalui:
1. **GAS Debugger**: Untuk melacak error di `kode.gs`.
2. **Browser Console**: Untuk memantau error JavaScript dan respons dari `google.script.run`.
3. **Live Testing**: Deployment sebagai Web App dengan izin akses terbatas.

## Area Kritis
- Alur Login (Sheet `Akun`).
- Pengiriman data darurat (SOS).
- Sinkronisasi saldo Kas (Sheet `UangKematian`).

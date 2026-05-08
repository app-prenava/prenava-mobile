# Stunting Food E2E Checklist

## Setup
- Login dengan user valid (token aktif)
- Pastikan user punya minimal 1 `prediction_id` dari skrining stunting

## Recommendation
- [ ] Buka `FoodRecommendationPage` dengan `prediction_id` valid
- [ ] Summary risiko dan probabilitas tampil benar
- [ ] Daftar `recommended_foods` tampil dengan chip nutrisi
- [ ] Badge `Ada Resep` muncul saat `has_recipe=true`
- [ ] Pull-to-refresh memuat ulang data tanpa crash

## Create & Current Meal Plan
- [ ] Tap `Buat Meal Plan` berhasil membuat plan baru
- [ ] Jika `GET /meal-plans/current` mengembalikan 404, tampil empty state + CTA
- [ ] Day chips (`Hari 1..n`) bisa dipilih dan konten meal berubah sesuai hari

## Completion Toggle (Optimistic)
- [ ] Toggle checklist meal item langsung berubah (optimistic)
- [ ] Jika API sukses, state tetap sesuai
- [ ] Simulasikan API gagal -> state rollback ke kondisi awal + error tampil

## Refresh Day
- [ ] Tap tombol `Refresh Hari Ini` memunculkan confirm dialog
- [ ] Setelah konfirmasi, menu hari terpilih berubah sesuai response API
- [ ] Jika request gagal, data lama tetap aman

## Progress
- [ ] Halaman progress menampilkan overall completion
- [ ] Progress tile per hari menampilkan % dan status benar
- [ ] Pull-to-refresh pada halaman progress berjalan baik

## Recipe
- [ ] Buka detail resep dari meal item
- [ ] Jika recipe tersedia, bahan dan langkah tampil
- [ ] Jika API recipe 404, fallback state tampil dengan CTA "Coba makanan lain"

## Auth & Error
- [ ] Saat token expired (401), app menjalankan logout/redirect login flow
- [ ] Error 500/network timeout menampilkan error state + tombol retry


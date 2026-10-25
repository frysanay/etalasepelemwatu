-- 1. Tabel pemilik
CREATE TABLE pemilik (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    no_telepon VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel kategori
CREATE TABLE kategori (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL UNIQUE,
    parent_id INTEGER,
    deskripsi TEXT
);

-- 3. Tabel etalase
CREATE TABLE etalase (
    id SERIAL PRIMARY KEY,
    pemilik_id INTEGER NOT NULL REFERENCES pemilik(id),
    nama VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'perlu_verifikasi',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabel penghubung etalase dan kategori
CREATE TABLE etalase_kategori (
    etalase_id INTEGER REFERENCES etalase(id) ON DELETE CASCADE,
    kategori_id INTEGER REFERENCES kategori(id) ON DELETE CASCADE,
    PRIMARY KEY (etalase_id, kategori_id)
);

-- 5. Tabel kontak etalase (one-to-one)
CREATE TABLE kontak_etalase (
    id SERIAL PRIMARY KEY,
    etalase_id INTEGER NOT NULL UNIQUE REFERENCES etalase(id) ON DELETE CASCADE,
    nama_kontak VARCHAR(100),
    no_telepon VARCHAR(20),
    email VARCHAR(100),
    media_sosial VARCHAR(150)
);

-- 6. Tabel alamat etalase (one-to-one)
CREATE TABLE alamat_etalase (
    id SERIAL PRIMARY KEY,
    etalase_id INTEGER NOT NULL UNIQUE REFERENCES etalase(id) ON DELETE CASCADE,
    alamat TEXT NOT NULL,
    desa VARCHAR(100) DEFAULT 'Pelemwatu',
    kecamatan VARCHAR(100) DEFAULT 'Menganti',
    kabupaten VARCHAR(100) DEFAULT 'Gresik'
);

-- 7. Tabel foto etalase (one-to-many)
CREATE TABLE foto_etalase (
    id SERIAL PRIMARY KEY,
    etalase_id INTEGER NOT NULL REFERENCES etalase(id) ON DELETE CASCADE,
    url_foto TEXT NOT NULL,
    keterangan VARCHAR(200)
);

-- 8. Tabel jam operasional (one-to-many)
CREATE TABLE jam_operasional (
    id SERIAL PRIMARY KEY,
    etalase_id INTEGER NOT NULL REFERENCES etalase(id) ON DELETE CASCADE,
    hari VARCHAR(15) NOT NULL,
    jam_buka TIME,
    jam_tutup TIME,
    tutup BOOLEAN DEFAULT FALSE,
    UNIQUE (etalase_id, hari)
);

-- DATA KATEGORI
INSERT INTO kategori (nama, deskripsi) VALUES
('Usaha dan Produk', 'Kategori usaha dan produk warga Desa Pelemwatu'),
('Makanan', 'Usaha makanan dan kuliner'),
('Warung Makan', 'Usaha warung makan'),
('Frozen Food', 'Usaha makanan beku'),
('Jasa', 'Layanan jasa masyarakat'),
('Laundry', 'Jasa pencucian pakaian'),
('Hunian', 'Informasi tempat tinggal dan kost');

UPDATE kategori
SET parent_id = 1
WHERE nama IN ('Makanan', 'Warung Makan', 'Frozen Food');

UPDATE kategori
SET parent_id = 5
WHERE nama = 'Laundry';

-- DATA PEMILIK (SIMULASI)
INSERT INTO pemilik (nama, email, no_telepon) VALUES
('Pemilik Omah Dimsum', 'omahdimsum@example.com', '081200000001'),
('Pemilik Selarasnasi', 'selarasnasi@example.com', '081200000002'),
('Pemilik Ratu Frozen Food', 'ratufrozen@example.com', '081200000003'),
('Pemilik Moni Laundry', 'monilaundry@example.com', '081200000004'),
('Pemilik One Laundry Koin', 'onelaundry@example.com', '081200000005'),
('Pemilik My Kost', 'mykost@example.com', '081200000006'),
('Pemilik RAMA Kost', 'ramakost@example.com', '081200000007');

-- DATA ETALASE
INSERT INTO etalase (pemilik_id, nama, deskripsi, status) VALUES
(1, 'Omah Dimsum', 'Usaha makanan dimsum.', 'data_simulasi'),
(2, 'Warung Prasmanan Selarasnasi', 'Usaha warung makan prasmanan.', 'data_simulasi'),
(3, 'Ratu Frozen Food Pelemwatu', 'Usaha penjualan makanan beku.', 'data_simulasi'),
(4, 'Moni Laundry 24 Jam', 'Jasa pencucian pakaian.', 'data_simulasi'),
(5, 'One Laundry Koin', 'Jasa laundry dengan sistem koin.', 'data_simulasi'),
(6, 'My Kost', 'Informasi hunian kost.', 'data_simulasi'),
(7, 'RAMA Kost', 'Informasi hunian kost.', 'data_simulasi');

-- RELASI ETALASE DAN KATEGORI
INSERT INTO etalase_kategori (etalase_id, kategori_id) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 6),
(5, 6),
(6, 7),
(7, 7);

-- DATA KONTAK (SIMULASI)
INSERT INTO kontak_etalase
(etalase_id, nama_kontak, no_telepon, email, media_sosial)
VALUES
(1, 'Kontak Omah Dimsum', '081200000001', 'omahdimsum@example.com', '@omahdimsum'),
(2, 'Kontak Selarasnasi', '081200000002', 'selarasnasi@example.com', '@selarasnasi'),
(3, 'Kontak Ratu Frozen Food', '081200000003', 'ratufrozen@example.com', '@ratufrozenfood'),
(4, 'Kontak Moni Laundry', '081200000004', 'monilaundry@example.com', '@monilaundry'),
(5, 'Kontak One Laundry Koin', '081200000005', 'onelaundry@example.com', '@onelaundry'),
(6, 'Kontak My Kost', '081200000006', 'mykost@example.com', '@mykost'),
(7, 'Kontak RAMA Kost', '081200000007', 'ramakost@example.com', '@ramakost');

-- DATA ALAMAT (SIMULASI)
INSERT INTO alamat_etalase (etalase_id, alamat) VALUES
(1, 'Jl. Raya Pelemwatu No. 1 (simulasi)'),
(2, 'Jl. Raya Pelemwatu No. 2 (simulasi)'),
(3, 'Jl. Raya Pelemwatu No. 3 (simulasi)'),
(4, 'Jl. Raya Pelemwatu No. 4 (simulasi)'),
(5, 'Jl. Raya Pelemwatu No. 5 (simulasi)'),
(6, 'Jl. Raya Pelemwatu No. 6 (simulasi)'),
(7, 'Jl. Raya Pelemwatu No. 7 (simulasi)');

-- DATA JAM OPERASIONAL (SIMULASI)
INSERT INTO jam_operasional
(etalase_id, hari, jam_buka, jam_tutup, tutup)
VALUES
(1, 'Senin', '08:00', '20:00', FALSE),
(2, 'Senin', '07:00', '14:00', FALSE),
(3, 'Senin', '08:00', '20:00', FALSE),
(4, 'Senin', '00:00', '23:59', FALSE),
(5, 'Senin', '08:00', '22:00', FALSE),
(6, 'Senin', '00:00', '23:59', FALSE),
(7, 'Senin', '00:00', '23:59', FALSE);

-- DATA FOTO PLACEHOLDER
INSERT INTO foto_etalase (etalase_id, url_foto, keterangan) VALUES
(1, 'https://placehold.co/600x400?text=Omah+Dimsum', 'Placeholder foto Omah Dimsum'),
(2, 'https://placehold.co/600x400?text=Selarasnasi', 'Placeholder foto Selarasnasi'),
(3, 'https://placehold.co/600x400?text=Ratu+Frozen+Food', 'Placeholder foto Ratu Frozen Food'),
(4, 'https://placehold.co/600x400?text=Moni+Laundry', 'Placeholder foto Moni Laundry'),
(5, 'https://placehold.co/600x400?text=One+Laundry+Koin', 'Placeholder foto One Laundry Koin'),
(6, 'https://placehold.co/600x400?text=My+Kost', 'Placeholder foto My Kost'),
(7, 'https://placehold.co/600x400?text=RAMA+Kost', 'Placeholder foto RAMA Kost');

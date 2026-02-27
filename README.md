# Tutorial Game Development 🎮
Nama  : Nisrina Annaisha Sarnadi  
NPM   : 2306275960

## Tutorial 3 - Proses Pengerjaan Game Platformer 2D
Pada tahap awal, permainan hanya terdiri dari beberapa **platform (ground)** yang disusun sebagai dasar permainan. Platform ini berfungsi sebagai tempat berpijak karakter dan membentuk jalur permainan dari awal hingga akhir level.

### Penambahan Player
Di awal, ditambahkan **player** menggunakan aset karakter zombie.

- Player menggunakan **CharacterBody2D** agar dapat memanfaatkan sistem physics bawaan Godot
- Ditambahkan **CollisionShape2D** agar player dapat berinteraksi dengan platform dan obstacle
- Ditambahkan **Sprite2D** sebagai visual karakter zombie di awal (Ada untuk sebagai tutorial awal, final: dihide)
- Ditambahkan **AnimatedSprite2D** sebagai visual karakter zombie

**Animasi Player**
Pada `AnimatedSprite2D`, ditambahkan beberapa animasi dengan sprite frames dari aset zombie, yaitu:
- `idle` (diam)
- `walk` (bergerak ke kiri dan kanan)
- `jump` (melompat)
- `fall` (jatuh)
- `hurt` (kesakitan)
- `win` (menang)  

Animasi ini digunakan untuk merepresentasikan kondisi player saat bermain

### Script Player dan Mekanik Gerak
Untuk memenuhi latihan yang ada, player dilengkapi dengan sebuah script untuk mengatur:
- Gerakan ke kiri dan kanan
- Lompat dan **double jump**
- Perubahan animasi berdasarkan kondisi (diam, berjalan, melompat, jatuh)
- Flip arah sprite saat bergerak ke kiri atau kanan
- Kondisi **hurt** saat key space ditekan, yang menampilkan animasi kesakitan

**Double Jump**    
Player dapat melompat 2 kali dengan menambahkan variable ```jump_count``` dan ```jump_max``` pada script player untuk membatasi jumlah lompatan saat karakter berada di udara. Jadi player tidak bisa lompat terus-terusan, hanya maksimal dua kali sebelum menyentuh tanah lagi.

### Penambahan Obstacle dan Platform Tambahan
Setelah player berfungsi dengan baik, ditambahkan beberapa **ground tambahan** sebagai obstacle:
- Platform di bagian bawah sebagai start point
- Platform di bagian tengah sesuai template
- Platform di atas yang menuju finish point

Alur permainan mengharuskan player:
1. Memulai dari platform bawah
2. Melompat ke platform tengah
3. Melompat lagi ke platform atas
4. Menuju area objective (flag)

### Objective Area (Flag)
Objective dibuat menggunakan **Area2D** yang diberi nama `Flag`.

Komponen Flag:
- **Area2D** sebagai trigger
- **CollisionShape2D** untuk mendeteksi player
- **Sprite2D** berupa gambar bendera

Ketika player memasuki area Flag:
- Game mendeteksi kemenangan
- Proses level dianggap selesai dan permainan diulang
- Ditambahkan animasi sederhana sebagai feedback kemenangan

### Asset tambahan
[https://www.freeiconspng.com/img/44306](https://www.pngall.com/red-flag-png/download/136243/)]  
[https://www.space.com/27600-around-a-star-system-space-wallpaper.html]
[https://www.dafont.com/my-game.font]

### Resource pengerjaan 
[https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html]    
[https://youtu.be/DW4CQoYddXQ?si=ViEQLVw2V-OVLx1y]

# Tutorial Game Development 🎮
Nama  : Nisrina Annaisha Sarnadi  
NPM   : 2306275960

[Tutorial 3 - Proses Pengerjaan Game Platformer 2D](tutorial-3)    
[Tutorial 5 - Penambahan Enemy, Interaksi, dan Audio](tutorial-5)

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
| Aset | Sumber |
|---|---|
| Gambar bendera merah | [pngall.com](https://www.pngall.com/red-flag-png/download/136243/) |
| Background luar angkasa | [space.com](https://www.space.com/27600-around-a-star-system-space-wallpaper.html) |
| Font game | [dafont.com/my-game](https://www.dafont.com/my-game.font) |

### Resource pengerjaan 
- https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html
- https://youtu.be/DW4CQoYddXQ?si=ViEQLVw2V-OVLx1y

## Tutorial 5 - Penambahan Enemy, Interaksi, dan Audio
Pada tutorial ini ditambahkan objek _enemy_ baru sebagai lawan pemain utama dan audio yang melatari permainan. 

### Pembuatan Objek Enemy
Enemy dibuat sebagai objek baru di dalam game yang bergerak secara otomatis dan dapat berinteraksi dengan player. Spritesheet enemy diambil dari **Game Art 2D — The Knight Free Sprites** berupa ksatria.     
Enemy menggunakan `CharacterBody2D` agar dapat berinteraksi dengan fisika dunia game seperti gravitasi dan tumbukan. `EnemyArea` berupa `Area2D` digunakan untuk mendeteksi ketika player menyentuh enemy.
 
#### Animasi Enemy dengan AnimatedSprite2D
Animasi enemy menggunakan `AnimatedSprite2D` agar objek bisa menyesuaikan kondisinya. Animasi yang dibuat di SpriteFrames:    
| Nama Animasi | Keterangan |
|---|---|
| `idle` | Enemy diam di tempat |
| `walk right` | Enemy berjalan kanan/kiri |
| `attack` | Enemy melakukan serangan |
| `dead` | Enemy mati |
 
Pengaturan flip sprite untuk menghadap kiri/kanan dilakukan menggunakan properti `flip_h` pada `AnimatedSprite2D`.
 
#### Perilaku Enemy (Patrol & Attack)
 
Enemy memiliki tiga fase perilaku yang berjalan secara otomatis menggunakan `Timer` dan `await`:
 
**Fase 1 — Idle (1 detik pertama)**    
Saat game dimulai, enemy diam selama 1 detik. Variabel `is_idle` memblokir pergerakan di `_physics_process` selama fase ini.
 
**Fase 2 — Walk (patrol kanan/kiri)**    
Setelah idle selesai, enemy mulai berjalan bolak-balik dalam jarak yang ditentukan oleh `patrol_distance`. Enemy membalik arah otomatis ketika melewati batas kiri atau kanan dari posisi awal (`start_x`).
 
**Fase 3 — Attack (bergantian setiap 1 detik)**    
Enemy berganti ke animasi `attack` selama 1 detik, lalu kembali ke walk. Siklus ini berulang terus menggunakan loop `while` di dalam fungsi `_on_timer_timeout`. Signal `timeout` dari node `Timer` diconnect ke fungsi tersebut.
 
### Interaksi Player dengan Enemy
 
**Enemy menyentuh player → level restart**    
Deteksi sentuhan menggunakan `EnemyArea (Area2D)`. Signal `body_entered` diconnect ke fungsi `_on_body_entered`. Ketika player menyentuh area enemy, fungsi `lose()` dipanggil pada player, lalu scene di-reload setelah delay singkat untuk memberi waktu animasi kalah bermain.
 
**Player menyerang enemy → enemy mati**    
Player dapat membunuh enemy dengan menekan tombol **Space**. Fungsi `_attack_enemy()` mengecek semua node dalam group `"enemy"` dan memanggil `die()` pada enemy yang berada dalam jarak tertentu dari player. Enemy harus ditambahkan ke group `"enemy"` melalui tab **Node → Groups** di Godot editor.
 
Fungsi `die()` pada enemy menghentikan timer, memainkan animasi `dead`, lalu memanggil `queue_free()` setelah animasi selesai melalui signal `animation_finished`.
 
### Sistem Menang dan Kalah
 
**Menang — Player mencapai Flag**    
Flag menggunakan `Area2D`. Ketika player menyentuh flag, fungsi `win()` dipanggil pada player, tampilan WinBG dan WinText dimunculkan, kemudian scene di-reload setelah 3 detik. Fungsi `win()` menghentikan physics process, mematikan BGM default, dan memainkan suara serta animasi menang.
 
**Kalah — Player menyentuh enemy**    
Fungsi `lose()` dipanggil dari enemy ketika player bersentuhan. Player berhenti bergerak, animasi kalah dimainkan, dan efek suara kalah diputar.
 
### Implementasi Audio
 
Audio dibagi menjadi dua kategori: **Background Music (BGM)** dan **Sound Effects (SFX)**.
 
**Background Music (BGM)**    
BGM diputar secara otomatis saat game berjalan dan di-loop terus-menerus. File audio berformat `.wav` diimport di Godot dengan pengaturan **Loop Mode: Forward** pada tab Import. BGM ditempatkan sebagai `AudioStreamPlayer` di node Root (Main scene) dengan **Autoplay: On**.
 
**Sound Effects (SFX)**    
SFX ditempatkan sebagai child node `AudioStreamPlayer` di dalam node Player:    
| Node | Trigger |
|---|---|
| `SFXAttack` | Saat player menekan Space untuk menyerang |
| `SFXLose` | Saat player menyentuh enemy dan kalah |
| `SFXWin` | Saat player mencapai flag dan menang |
| `SpaceAudio` | Audio default selama game, dimatikan saat menang |
 
SFX pada enemy:    
| Node | Trigger |
|---|---|
| `SFXDead` | Saat enemy mati melalui fungsi `die()` |        

Setiap SFX dipanggil dengan `namanode.play()` pada momen yang sesuai di dalam script.
 
### Audio Posisional (Relatif terhadap Posisi Objek)
 
Musik bahaya ditempatkan langsung di dalam node Enemy sebagai `DangerMusic (AudioStreamPlayer2D)`. Ketika player mendekati enemy, musik bahaya semakin keras. Ketika player menjauh, musik bahaya semakin samar. Efek ini terjadi otomatis tanpa kode tambahan karena `AudioStreamPlayer2D` menghitung jarak terhadap posisi listener secara real-time.
 
Pengaturan di Inspector:    
| Properti | Nilai | Keterangan |
|---|---|---|
| Stream | file musik bahaya | load file audio |
| Autoplay | On | langsung putar saat scene dimulai |
| Max Distance | 300 | jarak maksimal suara terdengar (pixel) |
| Attenuation | 1.0 | kecepatan penurunan volume per jarak |
 
Agar `AudioStreamPlayer2D` mengenali posisi player sebagai titik pendengar, ditambahkan node **AudioListener2D** di dalam scene Player.
 
### Aset yang Digunakan
| Aset | Sumber |
|---|---|
| Spritesheet enemy (Knight) | [gameart2d.com](https://www.gameart2d.com/the-knight-free-sprites.html) |
| SFX attack | [freesound.org — edwardszakal](https://freesound.org/people/edwardszakal/sounds/592752/) |
| SFX win | [freesound.org — LittleRobotSoundFactory](https://freesound.org/people/LittleRobotSoundFactory/sounds/270545/) |
| BGM | [freesound.org — luminousfridge](https://freesound.org/people/luminousfridge/sounds/496192/) |
| SFX lose / danger music | [freesound.org — HerbertBoland](https://freesound.org/people/HerbertBoland/sounds/114595/) |
 
### Referensi
- https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html
- https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html#audiostreamplayer
- https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer2d.html
- https://youtu.be/DW4CQoYddXQ?si=ViEQLVw2V-OVLx1y
 

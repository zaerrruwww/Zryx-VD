-- =============================================
-- DEMO KEY SYSTEM — WindUI built-in (Footagesus)
-- File TERPISAH, bukan bagian dari zryxvd.lua
--
-- CARA PAKAI: paste ke executor, execute.
--   Key valid demo: "demo123"  (atau "testing")
--   Tombol "Get key" -> copy link key site ke clipboard
--
-- CARA INTEGRASI KE SCRIPT KAMU NANTI:
--   Tinggal tambah blok KeySystem di dalam CreateWindow
--   (lihat config Window di bawah, bagian KeySystem = {...}),
--   nggak perlu bikin window/dialog tambahan.
-- =============================================

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title   = "zryx - DEMO",
    Author  = "Key System Demo",
    Folder  = "zryx",
    Icon    = "key",
    Theme   = "Dark",
    Size    = UDim2.fromOffset(680, 460),
    ToggleKey = Enum.KeyCode.RightShift,
    Resizable  = true,
    NewElements = true,

    -- =========================================
    -- KEY SYSTEM (bawaan WindUI)
    -- =========================================
    KeySystem = {
        -- Key statis: bisa string tunggal atau tabel berisi banyak key
        Key = { "demo123", "testing" },

        -- Simpan key yg valid ke file (Folder/"<Title>.key")
        -- -> next run TIDAK minta key lagi (bypass)
        SaveKey = true,

        -- URL key site (linkvertise dll) -> tombol "Get key"
        -- otomatis muncul & copy link ini ke clipboard
        URL = "https://linkvertise.com/", -- ganti dgn link kamu

        -- Judul & catatan popup
        Title = "zryx | Key System",
        Note = "Tekan <b>Get key</b>, buka link, salin key-nya, lalu submit.",

        -- Gambar samping (opsional)
        Thumbnail = {
            Image = "rbxassetid://94272208451726",
            Title = "zryx",
            Width = 200,
        },

        -- ALTERNATIF: verifikasi custom (ganti blok Key di atas dgn ini
        -- kalau mau logika cek sendiri, mis. cek via HTTP ke server):
        -- KeyValidator = function(input)
        --     return input == "demo123" or input == "testing"
        -- end,
    },
})

Window:SetUIScale(0.85)

-- Yang di bawah ini cuma supaya ada bukti "sudah unlock" di console
task.wait(1)
print("[DEMO] Window terbuka karena key valid.")
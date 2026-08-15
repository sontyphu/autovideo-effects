#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
lam_broll.py - CONG VAO cua skill dung-broll-collage.

Skill CHINH (bien tap video) ra lenh -> script nay sinh canh tram collage
-> tra ve file mp4 dung TUNG KHUNG HINH. Skill chinh tu ghep vao video.

Script KHONG tu tim cho tram, KHONG tu ghep. Do la viec cua skill chinh.

DUNG:
  # Mot canh
  python lam_broll.py --loi "AI cat ghep thay ban" --giay 4.0 --fps 30 --khung 9:16 \
      --ra "E:/Video-Projects/abc/broll/b1.mp4"

  # Ca loat (khuyen dung - nhanh hon, tu tranh trung mau)
  python lam_broll.py --bang yeucau.json --thu-muc "E:/Video-Projects/abc/broll"

  # Lay tong mau tu chinh video goc cho hop tone
  python lam_broll.py --bang yeucau.json --thu-muc out --tu-video "video-chinh.mp4"

MAU FILE --bang (JSON, moi dong 1 canh tram):
[
  {"loi": "moi ngay ban mat 2 tieng dung video", "bat_dau": 12.4, "ket_thuc": 16.1},
  {"loi": "AI lam thay ban trong 5 phut",        "giay": 3.5, "mau_nen": "#b3402e"}
]
  - Co "bat_dau"+"ket_thuc" -> do dai = hieu 2 so (uu tien).
  - Chi co "giay" -> dung so do.
  - Thieu ca hai -> loi, khong doan bua.

TRA VE: in JSON bang ke ra man hinh (skill chinh doc de biet duong dan + do dai that).
"""

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys

# Windows mac dinh in ra man hinh bang cp1252 -> duong dan/loi thoai co dau
# tieng Viet lam CHET script NGAY SAU KHI da render xong file (skill chinh
# tuong that bai). Ep UTF-8 truoc moi thu.
for _luong in (sys.stdout, sys.stderr):
    try:
        _luong.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

HERE = os.path.dirname(os.path.abspath(__file__))
TEMPLATE = os.path.normpath(os.path.join(HERE, "..", "assets", "template"))
def _cho_dung_xuong():
    """Xuong dung chung: cai 1 lan, tai dung mai (npm install rat cham).
    Chon cho hop voi TUNG MAY - khong ep o E (may hoc vien thuong khong co)."""
    tu_dat = os.environ.get("BROLL_XUONG")
    if tu_dat:
        return tu_dat
    ten = "_broll-collage-xuong"
    if os.name == "nt" and os.path.isdir("E:\\"):
        return os.path.join("E:\\", "Video-Projects", ten)   # may anh Son
    return os.path.join(os.path.expanduser("~"), "Video-Projects", ten)


XUONG = _cho_dung_xuong()

KHUNG = {
    "9:16": (1080, 1920),
    "16:9": (1920, 1080),
    "1:1": (1080, 1080),
    "4:5": (1080, 1350),
}

# ============================================================
# BANG CANH: chon AN DU HINH theo nghia cau noi.
# Day la phan quan trong nhat - khong co no thi moi cau deu ra cung mot hinh.
# Them canh moi: tao file src/canh/<Ten>.tsx -> dang ky trong Collage.tsx
# -> them 1 dong o day.
# ============================================================
BANG_CANH = [
    ("thoi-gian-troi", {
        "y": "thoi gian troi, mat thoi gian, cham chap, lam thu cong",
        "tu": ["thoi gian", "thời gian", "mat 2 tieng", "mất", "tieng dong ho", "cham",
               "chậm", "lau", "lâu", "ca ngay", "cả ngày", "hang gio", "hàng giờ",
               "thu cong", "thủ công", "moi ngay", "mỗi ngày", "tre", "trễ", "deadline",
               "ngay dem", "ngày đêm", "tiếng", "phut", "phút", "tuan", "tuần"],
    }),
    ("hon-loan-ngan-nap", {
        "y": "hon loan -> ngan nap, kien thuc rai rac, bo nao thu 2, he thong hoa",
        "tu": ["lon xon", "lộn xộn", "hon loan", "hỗn loạn", "bua bon", "bừa bộn",
               "rai rac", "rải rác", "that lac", "thất lạc", "quen", "quên", "tim lai",
               "tìm lại", "sap xep", "sắp xếp", "ngan nap", "ngăn nắp", "he thong hoa",
               "hệ thống hoá", "hệ thống hóa", "bo nao", "bộ não", "kien thuc", "kiến thức",
               "tai lieu", "tài liệu", "ghi chu", "ghi chú", "luu tru", "lưu trữ",
               "quan ly", "quản lý", "gon gang", "gọn gàng", "dong bo", "đồng bộ"],
    }),
    ("tang-truong", {
        "y": "tang truong, doanh thu, ket qua di len, nhan doi",
        "tu": ["tang truong", "tăng trưởng", "doanh thu", "loi nhuan", "lợi nhuận",
               "tang", "tăng", "gap doi", "gấp đôi", "nhan doi", "nhân đôi", "x2", "x3",
               "ket qua", "kết quả", "hieu qua", "hiệu quả", "don hang", "đơn hàng",
               "khach hang", "khách hàng", "ban duoc", "bán được", "tien", "tiền",
               "thu nhap", "thu nhập", "phat trien", "phát triển", "buoc nhay", "bứt phá"],
    }),
    ("may-lam-thay", {
        "y": "AI / may lam thay nguoi / tu dong hoa",
        "tu": ["ai lam", "ai se", "AI", "tu dong", "tự động", "may lam", "máy làm",
               "thay ban", "thay bạn", "thay nguoi", "thay người", "robot", "cong nghe",
               "công nghệ", "phan mem", "phần mềm", "cong cu", "công cụ", "tro ly",
               "trợ lý", "agent", "khong can lam", "không cần làm", "giai phong",
               "giải phóng", "chay ngam", "chạy ngầm", "24/7"],
    }),
    ("quay-cat-xuat-ban", {
        "y": "lam video, dung phim, quy trinh, cac buoc (canh mac dinh)",
        "tu": ["video", "quay", "dung phim", "dựng phim", "cat ghep", "cắt ghép",
               "bien tap", "biên tập", "hau ky", "hậu kỳ", "quy trinh", "quy trình",
               "cac buoc", "các bước", "reels", "tiktok", "youtube", "kenh", "kênh",
               "noi dung", "nội dung", "dang bai", "đăng bài"],
    }),
]
CANH_MAC_DINH = "quay-cat-xuat-ban"


def chon_canh(loi: str, da_dung: list):
    """Chon an du hinh theo nghia cau noi; tranh lap lai canh vua dung lien truoc."""
    t = (loi or "").lower()
    diem = []
    for ten, info in BANG_CANH:
        d = sum(1 for k in info["tu"] if k.lower() in t)
        if d:
            diem.append((d, ten))
    if not diem:
        return CANH_MAC_DINH
    diem.sort(reverse=True)
    # canh hop nhat; neu trung canh lien truoc thi lay canh hop nhi (do lap)
    if da_dung and diem[0][1] == da_dung[-1] and len(diem) > 1:
        return diem[1][1]
    return diem[0][1]


# Bang mau theo y nghia cau noi. Skill chinh khong chi dinh -> tu chon theo tu khoa.
BANG_MAU = [
    (["quy trinh", "quy trình", "he thong", "hệ thống", "cach lam", "cách làm",
      "dung video", "dựng video", "buoc", "bước"],
     {"bg": "#1b7d70", "accent": "#e8b23a", "pop": "#e0503a"}),
    (["sai lam", "sai lầm", "canh bao", "cảnh báo", "mat", "mất", "that bai",
      "thất bại", "dung lai", "dừng lại", "nguy"],
     {"bg": "#b3402e", "accent": "#e8b23a", "pop": "#f3ead6"}),
    (["tien", "tiền", "doanh thu", "loi nhuan", "lợi nhuận", "gia", "giá",
      "khach hang", "khách hàng", "ban", "bán"],
     {"bg": "#c9962e", "accent": "#1b7d70", "pop": "#b3402e"}),
    (["ai", "cong nghe", "công nghệ", "tuong lai", "tương lai", "tu dong",
      "tự động", "robot", "may", "máy"],
     {"bg": "#3b3560", "accent": "#e8b23a", "pop": "#e0503a"}),
]
MAU_MAC_DINH = {"bg": "#1b7d70", "accent": "#e8b23a", "pop": "#e0503a"}


def chon_mau(loi: str, da_dung: list):
    """Chon bo mau theo y nghia cau noi; tranh trung bo mau vua dung lien truoc."""
    t = (loi or "").lower()
    ung_vien = []
    for tu_khoa, mau in BANG_MAU:
        if any(k in t for k in tu_khoa):
            ung_vien.append(mau)
    if not ung_vien:
        ung_vien = [MAU_MAC_DINH]
    for m in ung_vien:
        if not da_dung or m["bg"] != da_dung[-1]:
            return m
    # moi ung vien deu trung canh truoc -> lay bo khac trong bang cho do lap
    for _, m in BANG_MAU:
        if not da_dung or m["bg"] != da_dung[-1]:
            return m
    return ung_vien[0]


def tong_mau_tu_video(video: str, giay: float):
    """Lay mau trung binh 1 khung tai moc -> de canh tram hop tone video chinh."""
    try:
        out = subprocess.run(
            ["ffmpeg", "-v", "error", "-ss", str(max(0, giay)), "-i", video,
             "-frames:v", "1", "-vf", "scale=1:1", "-f", "rawvideo",
             "-pix_fmt", "rgb24", "-"],
            capture_output=True, timeout=60,
        )
        b = out.stdout
        if len(b) >= 3:
            return "#%02x%02x%02x" % (b[0], b[1], b[2])
    except Exception:
        pass
    return None


def dau_van_tay_khuon():
    """Van tay cua khuon trong skill: ten + kich thuoc + ngay sua moi file src."""
    h = hashlib.sha1()
    src = os.path.join(TEMPLATE, "src")
    for goc, _, ten_ds in sorted(os.walk(src)):
        for t in sorted(ten_ds):
            p = os.path.join(goc, t)
            st = os.stat(p)
            h.update(os.path.relpath(p, src).encode())
            h.update(str(st.st_size).encode())
            h.update(str(int(st.st_mtime)).encode())
    return h.hexdigest()


def kiem_cong_cu():
    """Bao loi RO khi thieu cong cu, thay vi de npx chet kho hieu."""
    thieu = []
    for ten, lenh in (("node", "node -v"), ("npm", "npm -v")):
        try:
            r = subprocess.run(lenh, shell=True, capture_output=True, timeout=60)
            if r.returncode != 0:
                thieu.append(ten)
        except Exception:
            thieu.append(ten)
    if thieu:
        sys.exit(
            f"[loi] Thieu cong cu: {', '.join(thieu)}.\n"
            "      Cai Node.js (kem npm) tai https://nodejs.org roi chay lai.\n"
            "      Skill nay dung Remotion nen bat buoc co Node."
        )


def dung_xuong():
    """Cai xuong Remotion 1 lan; cac lan sau tai dung."""
    marker = os.path.join(XUONG, "node_modules", ".package-lock.json")
    if os.path.isfile(marker):
        return
    kiem_cong_cu()
    print(f"[xuong] Lan dau: dung xuong tai {XUONG} (chi cham lan nay)...", file=sys.stderr)
    os.makedirs(XUONG, exist_ok=True)
    for ten in ("package.json", "tsconfig.json", "remotion.config.ts"):
        src = os.path.join(TEMPLATE, ten)
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(XUONG, ten))
    src_src = os.path.join(TEMPLATE, "src")
    dst_src = os.path.join(XUONG, "src")
    if os.path.isdir(dst_src):
        shutil.rmtree(dst_src)
    shutil.copytree(src_src, dst_src)
    r = subprocess.run("npm install", cwd=XUONG, shell=True)
    if r.returncode != 0:
        sys.exit("[xuong] npm install that bai - kiem tra node/npm.")


def dong_bo_khuon(ep=False):
    """Chep khuon moi nhat tu skill sang xuong.

    TU DONG: so van tay khuon; khac la chep lai. Khong bat nguoi dung nho
    goi --dong-bo, vi quen la render bang khuon CU ma khong he bao loi.
    """
    van_tay_file = os.path.join(XUONG, ".van-tay-khuon")
    moi = dau_van_tay_khuon()
    cu = None
    if os.path.isfile(van_tay_file):
        try:
            with open(van_tay_file, "r", encoding="utf-8") as f:
                cu = f.read().strip()
        except Exception:
            pass
    if not ep and cu == moi:
        return False
    dst_src = os.path.join(XUONG, "src")
    if os.path.isdir(dst_src):
        shutil.rmtree(dst_src)
    shutil.copytree(os.path.join(TEMPLATE, "src"), dst_src)
    for ten in ("package.json", "tsconfig.json", "remotion.config.ts"):
        src = os.path.join(TEMPLATE, ten)
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(XUONG, ten))
    with open(van_tay_file, "w", encoding="utf-8") as f:
        f.write(moi)
    print("[xuong] Khuon trong skill da doi -> da dong bo sang xuong.", file=sys.stderr)
    return True


def go_luong_tieng(duong_dan):
    """Go luong tieng rong khoi canh tram (ghep vao video chinh se an toan hon).
    Chi chep luong hinh, khong ma hoa lai -> nhanh va khong giam chat luong."""
    try:
        co = subprocess.run(
            ["ffprobe", "-v", "error", "-select_streams", "a", "-show_entries",
             "stream=index", "-of", "csv=p=0", duong_dan],
            capture_output=True, timeout=120,
        )
        if not co.stdout.strip():
            return  # von da cam
        tam = duong_dan + ".tam.mp4"
        r = subprocess.run(
            ["ffmpeg", "-v", "error", "-y", "-i", duong_dan, "-c", "copy", "-an", tam],
            capture_output=True, timeout=600,
        )
        if r.returncode == 0 and os.path.isfile(tam):
            os.replace(tam, duong_dan)
        elif os.path.isfile(tam):
            os.remove(tam)
    except Exception:
        pass


def do_file(duong_dan):
    """Do file that bang ffprobe: so khung, fps, kich thuoc, co tieng khong."""
    try:
        r = subprocess.run(
            ["ffprobe", "-v", "error", "-select_streams", "v:0", "-count_frames",
             "-show_entries", "stream=width,height,r_frame_rate,nb_read_frames",
             "-of", "json", duong_dan],
            capture_output=True, timeout=300,
        )
        v = json.loads(r.stdout.decode("utf-8", "ignore"))["streams"][0]
        rate = v.get("r_frame_rate", "0/1").split("/")
        fps = round(float(rate[0]) / float(rate[1] or 1), 3)
        a = subprocess.run(
            ["ffprobe", "-v", "error", "-select_streams", "a", "-show_entries",
             "stream=index", "-of", "csv=p=0", duong_dan],
            capture_output=True, timeout=120,
        )
        return {
            "so_khung": int(v.get("nb_read_frames", 0)),
            "fps": fps,
            "rong": int(v.get("width", 0)),
            "cao": int(v.get("height", 0)),
            "co_tieng": bool(a.stdout.strip()),
        }
    except Exception:
        return None


def render_mot(yeu_cau: dict, fps: int, khung: str, thu_muc: str, idx: int,
               da_dung_mau: list, video_goc: str = None, da_dung_canh: list = None,
               xem_truoc: bool = False):
    loi = (yeu_cau.get("loi") or "").strip()
    if da_dung_canh is None:
        da_dung_canh = []

    # --- DO DAI: khop tung khung hinh, khong lam tron bua ---
    if "bat_dau" in yeu_cau and "ket_thuc" in yeu_cau:
        giay = float(yeu_cau["ket_thuc"]) - float(yeu_cau["bat_dau"])
    elif "giay" in yeu_cau:
        giay = float(yeu_cau["giay"])
    else:
        sys.exit(f"[loi] Dong {idx}: thieu do dai. Can 'bat_dau'+'ket_thuc' hoac 'giay'.")
    if giay <= 0:
        sys.exit(f"[loi] Dong {idx}: do dai phai > 0 (dang la {giay}).")

    f = int(yeu_cau.get("fps", fps))
    # LUAT CUNG: so khung = lam tron(giay x fps).
    # Dung int(x+0.5) chu KHONG dung round() - round() cua Python lam tron ve so
    # chan (62.5 -> 62), gay lech khung ngoai du doan cua skill chinh.
    so_khung = max(1, int(giay * f + 0.5))

    k = yeu_cau.get("khung", khung)
    if k not in KHUNG:
        sys.exit(f"[loi] Dong {idx}: khung '{k}' khong ho tro. Chon: {', '.join(KHUNG)}")
    w, h = KHUNG[k]

    # --- MAU ---
    mau = dict(MAU_MAC_DINH)
    tu_dong = chon_mau(loi, da_dung_mau)
    mau.update(tu_dong)
    if video_goc and "bat_dau" in yeu_cau:
        m = tong_mau_tu_video(video_goc, float(yeu_cau["bat_dau"]))
        if m:
            mau["bg"] = m  # bam tone video chinh
    for kh, key in (("mau_nen", "bg"), ("mau_nhan", "accent"), ("mau_chot", "pop")):
        if yeu_cau.get(kh):
            mau[key] = yeu_cau[kh]  # skill chinh chi dinh -> uu tien cao nhat
    da_dung_mau.append(mau["bg"])

    ten = yeu_cau.get("ra") or os.path.join(thu_muc, f"broll-{idx:02d}.mp4")
    os.makedirs(os.path.dirname(os.path.abspath(ten)) or ".", exist_ok=True)

    # --- CANH (an du hinh): skill chinh chi dinh, khong thi tu chon theo cau noi ---
    canh = yeu_cau.get("canh") or chon_canh(loi, da_dung_canh)
    da_dung_canh.append(canh)

    props = {
        "durationInFrames": so_khung,
        "fps": f,
        "width": w,
        "height": h,
        "scene": canh,
        **mau,
    }
    if xem_truoc:
        # Duyet RE: chi ra 1 anh tinh khung cuoi, khong render ca video
        ten = os.path.splitext(ten)[0] + ".png"
        cmd = ["npx", "remotion", "still", "Collage", ten,
               "--frame", str(max(0, so_khung - 6)),
               "--props", json.dumps(props, ensure_ascii=False)]
    else:
        # --muted: canh tram PHAI cam. Remotion van co the nhet luong tieng rong
        # -> go han o buoc duoi bang ffmpeg.
        cmd = ["npx", "remotion", "render", "Collage", ten, "--muted",
               "--props", json.dumps(props, ensure_ascii=False)]
    r = subprocess.run(cmd, cwd=XUONG, shell=True)
    if r.returncode != 0:
        sys.exit(f"[loi] Dong {idx}: render that bai.")

    if not xem_truoc:
        go_luong_tieng(ten)

    if xem_truoc:
        return {"stt": idx, "loi": loi, "file": os.path.abspath(ten),
                "xem_truoc": True, "canh": canh, "khung": k, "mau_nen": mau["bg"]}

    # --- TU KIEM (R17): do file that, khong tin "render xong la dung" ---
    do = do_file(ten)
    canh_bao = []
    if do:
        if do["so_khung"] != so_khung:
            canh_bao.append(f"so khung lech: yeu cau {so_khung}, file co {do['so_khung']}")
        if abs(do["fps"] - f) > 0.05:
            canh_bao.append(f"fps lech: yeu cau {f}, file co {do['fps']}")
        if (do["rong"], do["cao"]) != (w, h):
            canh_bao.append(f"kich thuoc lech: yeu cau {w}x{h}, file co {do['rong']}x{do['cao']}")
        if do["co_tieng"]:
            canh_bao.append("file CO tieng - canh tram phai cam")
    else:
        canh_bao.append("khong do duoc bang ffprobe (thieu ffmpeg?)")
    for c in canh_bao:
        print(f"  [!] Dong {idx}: {c}", file=sys.stderr)

    return {
        "stt": idx,
        "loi": loi,
        "file": os.path.abspath(ten),
        "giay": round(so_khung / f, 4),   # do dai THAT sau lam tron khung
        "so_khung": so_khung,
        "fps": f,
        "khung": k,
        "canh": canh,
        "dat_chuan": not canh_bao,
        "canh_bao": canh_bao,
        "mau_nen": mau["bg"],
        "bat_dau": yeu_cau.get("bat_dau"),
        "ket_thuc": yeu_cau.get("ket_thuc"),
    }


def main():
    p = argparse.ArgumentParser(
        description="Sinh canh tram B-roll cat dan giay. Skill chinh goi, tu ghep.")
    p.add_argument("--bang", help="File JSON nhieu yeu cau (khuyen dung)")
    p.add_argument("--loi", help="Cau thoai tai cho tram (che do 1 canh)")
    p.add_argument("--giay", type=float, help="Do dai canh tram (giay)")
    p.add_argument("--bat-dau", type=float, help="Moc bat dau tren video chinh")
    p.add_argument("--ket-thuc", type=float, help="Moc ket thuc tren video chinh")
    p.add_argument("--fps", type=int, default=30, help="PHAI bang fps video chinh (mac dinh 30)")
    p.add_argument("--khung", default="9:16", choices=list(KHUNG), help="Ti le khung")
    p.add_argument("--ra", help="Duong dan file ra (che do 1 canh)")
    p.add_argument("--thu-muc", default="broll-out", help="Thu muc chua ca loat")
    p.add_argument("--tu-video", help="Video chinh: lay tong mau tai moc cho hop tone")
    p.add_argument("--mau-nen", help="Ep mau nen (vd #1b7d70)")
    p.add_argument("--canh", help="Ep an du hinh (xem --list-canh); bo trong = tu chon theo cau noi")
    p.add_argument("--xem-truoc", action="store_true",
                   help="Chi ra ANH TINH khung cuoi de duyet (nhanh, re) - khong render video")
    p.add_argument("--dong-bo", action="store_true", help="Ep chep lai khuon (thuong tu dong)")
    p.add_argument("--list-canh", action="store_true", help="In danh sach an du hinh co san roi thoat")
    a = p.parse_args()

    if a.list_canh:
        print("CAC AN DU HINH CO SAN:\n")
        for ten, info in BANG_CANH:
            print(f"  {ten:<20} {info['y']}")
        print(f"\nMac dinh khi khong khop tu khoa nao: {CANH_MAC_DINH}")
        return

    dung_xuong()
    dong_bo_khuon(ep=a.dong_bo)  # TU DONG so van tay: khuon doi thi tu chep sang xuong

    if a.bang:
        with open(a.bang, "r", encoding="utf-8") as f:
            ds = json.load(f)
        if not isinstance(ds, list) or not ds:
            sys.exit("[loi] File --bang phai la danh sach yeu cau, khong rong.")
    else:
        if not a.loi:
            sys.exit("[loi] Can --loi (che do 1 canh) hoac --bang (ca loat).")
        mot = {"loi": a.loi}
        if a.bat_dau is not None and a.ket_thuc is not None:
            mot["bat_dau"], mot["ket_thuc"] = a.bat_dau, a.ket_thuc
        elif a.giay is not None:
            mot["giay"] = a.giay
        else:
            sys.exit("[loi] Can --giay hoac ca --bat-dau va --ket-thuc.")
        if a.ra:
            mot["ra"] = a.ra
        if a.mau_nen:
            mot["mau_nen"] = a.mau_nen
        if a.canh:
            mot["canh"] = a.canh
        ds = [mot]

    ten_canh_hop_le = [t for t, _ in BANG_CANH]
    for i, yc in enumerate(ds, 1):
        if yc.get("canh") and yc["canh"] not in ten_canh_hop_le:
            sys.exit(f"[loi] Dong {i}: canh '{yc['canh']}' khong co. "
                     f"Xem --list-canh. Co: {', '.join(ten_canh_hop_le)}")

    ket_qua, da_dung, da_canh = [], [], []
    for i, yc in enumerate(ds, 1):
        print(f"[{i}/{len(ds)}] {yc.get('loi','')[:60]}", file=sys.stderr)
        ket_qua.append(render_mot(yc, a.fps, a.khung, a.thu_muc, i, da_dung,
                                  a.tu_video, da_canh, a.xem_truoc))

    # Bang ke tra ve cho skill chinh
    hong = [r for r in ket_qua if r.get("dat_chuan") is False]
    print(json.dumps({
        "so_canh": len(ket_qua),
        "dat_chuan_het": not hong,
        "canh": ket_qua,
    }, ensure_ascii=False, indent=2))
    if hong:
        print(f"\n[!] {len(hong)} canh KHONG dat chuan - xem 'canh_bao'. "
              "Dung ghep vao video cho toi khi sua xong.", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()

import 'dart:io';

// --- PHẦN 1: CÁC LỚP (CLASS) ---

abstract class PhongTro {
  String maPhong;
  int soNguoi;
  int soDien;
  int soNuoc;

  PhongTro(this.maPhong, this.soNguoi, this.soDien, this.soNuoc);

  double tinhTien(); // Hàm trừu tượng

  @override
  String toString() {
    return '$maPhong: $soNguoi người | Điện: $soDien | Nước: $soNuoc';
  }
}

class PhongLoaiA extends PhongTro {
  int soNguoiThan;

  PhongLoaiA(String ma, int nguoi, int dien, int nuoc, this.soNguoiThan)
      : super(ma, nguoi, dien, nuoc);

  @override
  double tinhTien() {
    return 1400.0 + (2 * soDien) + (8 * soNuoc) + (50 * soNguoiThan);
  }

  @override
  String toString() {
    return '${super.toString()} | Thân nhân: $soNguoiThan | => TIỀN: ${tinhTien()}';
  }
}

class PhongLoaiB extends PhongTro {
  int giatUi;
  int soMay;

  PhongLoaiB(String ma, int nguoi, int dien, int nuoc, this.giatUi, this.soMay)
      : super(ma, nguoi, dien, nuoc);

  @override
  double tinhTien() {
    return 2000.0 + (2 * soDien) + (8 * soNuoc) + (5 * giatUi) + (100 * soMay);
  }

  @override
  String toString() {
    return '${super.toString()} | Giặt: $giatUi kg | Máy: $soMay | => TIỀN: ${tinhTien()}';
  }
}

// --- PHẦN 2: XỬ LÝ CHÍNH ---

void main() async {
  List<PhongTro> danhSach = [];

  // 1. Đọc file
  try {
    final file = File('phongthue.txt');
    if (!await file.exists()) {
      print('Lỗi: Chưa tạo file phongthue.txt ở thư mục gốc!');
      return;
    }

    List<String> lines = await file.readAsLines();
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      var parts = line.split('#');
      
      String ma = parts[0];
      int nguoi = int.parse(parts[1]);
      int dien = int.parse(parts[2]);
      int nuoc = int.parse(parts[3]);

      if (ma.startsWith('A')) {
        danhSach.add(PhongLoaiA(ma, nguoi, dien, nuoc, int.parse(parts[4])));
      } else if (ma.startsWith('B')) {
        danhSach.add(PhongLoaiB(ma, nguoi, dien, nuoc, int.parse(parts[4]), int.parse(parts[5])));
      }
    }
  } catch (e) {
    print('Lỗi đọc file: $e');
  }

  // 2. In danh sách
  print('\n--- a. DANH SÁCH PHÒNG ---');
  danhSach.forEach(print);

  // 3. In phòng > 2 người
  print('\n--- b. PHÒNG > 2 NGƯỜI ---');
  for (var p in danhSach) {
    if (p.soNguoi > 2) print(p);
  }

  // 4. Tổng tiền
  double tong = 0;
  for (var p in danhSach) tong += p.tinhTien();
  print('\n--- c. TỔNG TIỀN: ${tong.toStringAsFixed(0)} ---');

  // 5. Sắp xếp theo điện giảm dần
  danhSach.sort((a, b) => b.soDien.compareTo(a.soDien));
  print('\n--- d. SAU KHI SẮP XẾP (ĐIỆN GIẢM DẦN) ---');
  danhSach.forEach((p) => print('Phòng ${p.maPhong}: ${p.soDien} số điện'));

  // 6. In phòng loại A
  print('\n--- e. CHỈ PHÒNG LOẠI A ---');
  for (var p in danhSach) {
    if (p is PhongLoaiA) print(p);
  }
}
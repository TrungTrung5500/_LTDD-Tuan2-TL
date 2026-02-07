import 'dart:io';
import 'dart:math';

// --- CÁC CLASS ---
abstract class MonHoc {
  String maMon, tenMon;
  int soTinChi;
  MonHoc(this.maMon, this.tenMon, this.soTinChi);
  double tinhDTB();
  
  double quyDoiHe4() {
    double dtb = tinhDTB();
    if (dtb >= 8.5) return 4.0;
    if (dtb >= 7.0) return 3.0;
    if (dtb >= 5.5) return 2.0;
    if (dtb >= 4.0) return 1.0;
    return 0.0;
  }

  @override
  String toString() => '[$maMon] $tenMon ($soTinChi TC) | ĐTB: ${tinhDTB().toStringAsFixed(1)} | Hệ 4: ${quyDoiHe4()}';
}

class LyThuyet extends MonHoc {
  double tl, ck;
  LyThuyet(String ma, String ten, int tc, this.tl, this.ck) : super(ma, ten, tc);
  @override double tinhDTB() => (tl * 0.3) + (ck * 0.7);
}

class ThucHanh extends MonHoc {
  double d1, d2, d3;
  ThucHanh(String ma, String ten, int tc, this.d1, this.d2, this.d3) : super(ma, ten, tc);
  @override double tinhDTB() => (d1 + d2 + d3) / 3;
}

class DoAn extends MonHoc {
  double gvhd, gvpb;
  DoAn(String ma, String ten, int tc, this.gvhd, this.gvpb) : super(ma, ten, tc);
  @override double tinhDTB() => (gvhd + gvpb) / 2;
}

// --- CHƯƠNG TRÌNH CHÍNH ---
void main() async {
  List<MonHoc> ds = [];
  
  // 1. Đọc file
  try {
    final lines = await File('monhoc.txt').readAsLines();
    for (var line in lines) {
      if (line.trim().isEmpty) continue;
      var arr = line.split(',');
      String loai = arr[0], ma = arr[1], ten = arr[2];
      int tc = int.parse(arr[3]);
      
      if (loai == 'LT') ds.add(LyThuyet(ma, ten, tc, double.parse(arr[4]), double.parse(arr[5])));
      if (loai == 'TH') ds.add(ThucHanh(ma, ten, tc, double.parse(arr[4]), double.parse(arr[5]), double.parse(arr[6])));
      if (loai == 'DA') ds.add(DoAn(ma, ten, tc, double.parse(arr[4]), double.parse(arr[5])));
    }
  } catch (e) { print('Lỗi đọc file: $e'); return; }

  // 2. Xuất danh sách
  print('\n--- DANH SÁCH MÔN HỌC ---');
  ds.forEach(print);

  // 3. Sắp xếp theo Tín chỉ
  ds.sort((a, b) => a.soTinChi.compareTo(b.soTinChi));
  print('\n--- SAU KHI SẮP XẾP (TÍN CHỈ TĂNG DẦN) ---');
  ds.forEach(print);

  // 4. Tìm kiếm và Thêm
  stdout.write('\nNhập tên môn cần tìm: ');
  String? tenCanTim = stdin.readLineSync();
  if (tenCanTim != null) {
    try {
      var kq = ds.firstWhere((m) => m.tenMon.toLowerCase().contains(tenCanTim.toLowerCase()));
      print('=> Tìm thấy: $kq');
    } catch (e) {
      print('=> Không tìm thấy. Đang thêm mới môn "$tenCanTim" vào danh sách...');
      ds.add(LyThuyet('NEW01', tenCanTim, 3, 7.0, 8.0)); // Thêm nhanh môn mẫu
      print('=> Đã thêm thành công!');
    }
  }
}
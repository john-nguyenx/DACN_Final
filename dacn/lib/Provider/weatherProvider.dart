import 'dart:async'; // Nhập thư viện cho các tác vụ bất đồng bộ
import 'package:dacn/Model/weather_model.dart'; // Nhập mô hình dữ liệu thời tiết
import 'package:dacn/Service/weatherService.dart'; // Nhập dịch vụ thời tiết
import 'package:flutter/material.dart'; // Nhập thư viện Flutter

class WeatherProvider with ChangeNotifier {
  WeatherData? _weatherData; // Biến lưu trữ dữ liệu thời tiết
  String? _error; // Biến lưu trữ thông báo lỗi
  bool _isLoading = false; // Trạng thái loading để quản lý quá trình tải dữ liệu
  Timer? _timer; // Biến timer để thực hiện tự động làm mới dữ liệu

  // Getter để lấy thông tin thời tiết
  WeatherData? get weatherData => _weatherData;

  // Getter để lấy thông báo lỗi
  String? get error => _error;

  // Getter để kiểm tra trạng thái loading
  bool get isLoading => _isLoading;

  final WeatherService _weatherService = WeatherService(); // Khởi tạo WeatherService

  // Hàm để lấy dữ liệu thời tiết
  Future<void> fetchWeather() async {
    _isLoading = true; // Đánh dấu trạng thái loading
    notifyListeners(); // Thông báo cho các listener về sự thay đổi

    try {
      _weatherData = await _weatherService.fetchWeather(); // Lấy dữ liệu thời tiết từ dịch vụ
      _error = null; // Reset thông báo lỗi nếu thành công
    } catch (e) {
      _error = e.toString(); // Lưu thông báo lỗi nếu có lỗi xảy ra
    } finally {
      _isLoading = false; // Đặt trạng thái loading về false
      notifyListeners(); // Thông báo cho các listener về sự thay đổi
    }
  }

  // Hàm bắt đầu tự động làm mới dữ liệu
  void startAutoRefreshing() {
    _timer?.cancel(); // Hủy timer nếu đang chạy
    _timer = Timer.periodic(const Duration(minutes: 10), (timer) {
      fetchWeather(); // Gọi hàm để lấy dữ liệu thời tiết mới mỗi 10 phút
    });
  }

  // Hàm dừng tự động làm mới dữ liệu
  void stopAutoRefreshing() {
    _timer?.cancel(); // Hủy timer nếu tồn tại
  }
}

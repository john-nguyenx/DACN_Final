import 'dart:convert'; // Nhập thư viện để xử lý JSON
import 'package:dacn/Model/weather_model.dart'; // Nhập mô hình dữ liệu thời tiết
import 'package:geolocator/geolocator.dart'; // Nhập thư viện để lấy vị trí địa lý
import 'package:http/http.dart' as http; // Nhập thư viện HTTP

class WeatherService {
  final String _apiKey = "befe89839e80e0a7c1ecdf5708af00ab"; // Khóa API cho OpenWeather

  // Hàm để lấy dữ liệu thời tiết
  Future<WeatherData?> fetchWeather() async {
    try {
      // Yêu cầu vị trí hiện tại
      Position position = await _determinePosition(); // Định vị vị trí
      print("Current Position: $position"); // In ra vị trí hiện tại

      // Gửi yêu cầu đến API thời tiết
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather"
          "?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey", // Thêm thông tin vị trí và khóa API
        ),
      );

      // Kiểm tra mã trạng thái của phản hồi
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body); // Giải mã JSON
        return WeatherData.fromJson(json); // Chuyển đổi dữ liệu JSON thành đối tượng WeatherData
      } else {
        print('Failed to load Weather data: ${response.statusCode}'); // In ra lỗi nếu không tải được dữ liệu
        return null; // Trả về null nếu không thành công
      }
    } catch (e) {
      print("Error occurred: $e"); // In ra lỗi nếu có
      return null; // Trả về null nếu có lỗi
    }
  }

  // Phương thức để xác định vị trí
  Future<Position> _determinePosition() async {
    // Kiểm tra xem dịch vụ định vị có được kích hoạt không
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.'); // Nếu không, trả về lỗi
    }

    LocationPermission permission = await Geolocator.checkPermission(); // Kiểm tra quyền truy cập vị trí
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // Yêu cầu quyền nếu bị từ chối
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'); // Trả về lỗi nếu quyền vẫn bị từ chối
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'); // Nếu quyền bị từ chối vĩnh viễn
    }

    // Nếu quyền được cấp, tiếp tục lấy vị trí
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); // Lấy vị trí hiện tại với độ chính xác cao
  }
}

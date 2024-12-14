import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GymScreen extends StatefulWidget {
  const GymScreen({super.key});

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> {
  // Danh sách các bài tập Gym cơ bản
  final List<String> gymExercises = [
    'Chạy Bộ',
    'Nhảy Dây',
    'Squat',
    'Đẩy Ngực',
    'Tập Bắp Tay',
  ];

  // Danh sách các bước cho bài tập "Chạy Bộ"
  final List<String> runningSteps = [
    'Khởi động: Làm nóng cơ thể trong 5-10 phút.',
    'Bắt đầu chạy: Giữ tốc độ chậm và đều.',
    'Duy trì tư thế: Lưng thẳng, đầu ngẩng cao.',
    'Thở đều: Hít thở sâu và đều đặn.',
    'Kết thúc: Giảm tốc độ và làm mát cơ thể.',
  ];

  // Danh sách các bước cho bài tập "Nhảy Dây"
  final List<String> skippingSteps = [
    'Chọn dây: Chọn dây có độ dài phù hợp với chiều cao của bạn.',
    'Khởi động: Làm nóng cơ thể trong 5-10 phút.',
    'Bắt đầu nhảy: Nhảy nhẹ nhàng, giữ đều nhịp.',
    'Duy trì tư thế: Giữ lưng thẳng, mắt nhìn thẳng.',
    'Kết thúc: Giảm nhịp và làm mát cơ thể.',
  ];

  // Danh sách các bước cho bài tập "Squat"
  final List<String> squatSteps = [
    'Khởi động: Làm nóng cơ thể trong 5-10 phút.',
    'Bắt đầu squat: Đứng thẳng, chân rộng bằng vai.',
    'Hạ người: Cong gối và hạ người xuống như ngồi trên ghế.',
    'Duy trì tư thế: Lưng thẳng, đầu gối không vượt quá mũi chân.',
    'Đứng lên: Dùng lực chân để đứng thẳng trở lại.',
    'Kết thúc: Giảm nhịp và làm mát cơ thể.',
  ];

  // Danh sách các bước cho bài tập "Đẩy Ngực"
  final List<String> chestPressSteps = [
    'Khởi động: Làm nóng cơ thể trong 5-10 phút.',
    'Chuẩn bị: Nằm trên ghế đẩy ngực, chân đặt vững chắc trên sàn.',
    'Bắt đầu đẩy: Cầm thanh đẩy, đẩy lên cho đến khi tay thẳng.',
    'Hạ xuống: Hạ thanh đẩy xuống ngực, khuỷu tay tạo góc 90 độ.',
    'Duy trì tư thế: Lưng giữ thẳng, không nâng hông.',
    'Kết thúc: Đặt thanh đẩy trở lại giá đỡ và làm mát cơ thể.',
  ];

  // Danh sách các bước cho bài tập "Tập Bắp Tay"
  final List<String> bicepCurlSteps = [
    'Khởi động: Làm nóng cơ thể trong 5-10 phút.',
    'Chuẩn bị: Đứng thẳng, cầm tạ tay ở hai bên.',
    'Bắt đầu cuốn: Cuốn tạ lên cho đến khi tay gập lại hoàn toàn.',
    'Hạ xuống: Hạ tạ xuống vị trí ban đầu.',
    'Duy trì tư thế: Lưng thẳng, không lắc lư cơ thể.',
    'Kết thúc: Giảm nhịp và làm mát cơ thể.',
  ];

  // URL của video hướng dẫn
  final String runningVideoUrl = 'https://www.youtube.com/watch?v=kTbQ8C9EXWk';
  final String skippingVideoUrl = 'https://www.youtube.com/watch?v=7Sg8sP8SdK4';
  final String squatVideoUrl = 'https://www.youtube.com/results?search_query=squat';
  final String chestPressVideoUrl = 'https://www.youtube.com/shorts/VFSAo-Chepw';
  final String bicepCurlVideoUrl = 'https://www.youtube.com/watch?v=RkvZpXcF-jo';

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // Sử dụng phương thức launchUrl với Uri để mở video YouTube
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Không thể mở URL: $url';
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể mở URL: $url. Error: $e'),
        ),
      );
    }
  }

  void showExerciseDetails(String exercise) {
    List<String> steps = [];
    String videoUrl = '';

    if (exercise == 'Chạy Bộ') {
      steps = runningSteps;
      videoUrl = runningVideoUrl;
    } else if (exercise == 'Nhảy Dây') {
      steps = skippingSteps;
      videoUrl = skippingVideoUrl;
    } else if (exercise == 'Squat') {
      steps = squatSteps;
      videoUrl = squatVideoUrl;
    } else if (exercise == 'Đẩy Ngực') {
      steps = chestPressSteps;
      videoUrl = chestPressVideoUrl;
    } else if (exercise == 'Tập Bắp Tay') {
      steps = bicepCurlSteps;
      videoUrl = bicepCurlVideoUrl;
    }

    if (steps.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(exercise),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ...steps.map((step) => Text(step)).toList(),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _launchURL(videoUrl);
                    },
                    child: Text(
                      'Xem video hướng dẫn',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Hiển thị thông tin chi tiết chung cho các bài tập khác
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(exercise),
            content: Text('Thông tin chi tiết về bài tập: $exercise'),
            actions: <Widget>[
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Các Bài Tập Gym'),
      ),
      body: ListView.builder(
        itemCount: gymExercises.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(gymExercises[index]),
              onTap: () {
                showExerciseDetails(gymExercises[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

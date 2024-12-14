import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YogaScreen extends StatefulWidget {
  const YogaScreen({super.key});

  @override
  State<YogaScreen> createState() => _YogaScreenState();
}

class _YogaScreenState extends State<YogaScreen> {
  // Danh sách các bài tập Yoga cơ bản
  final List<String> yogaExercises = [
    'Tư thế Cây',
    'Tư thế Chiến binh',
    'Tư thế Cầu',
    'Tư thế Chó úp mặt',
    'Tư thế Đứa trẻ',
  ];

  // Danh sách các bước cho bài tập "Tư Thế Cây"
  final List<String> treePoseSteps = [
    'Đứng thẳng, đặt bàn chân sát nhau.',
    'Đưa một chân lên, đặt lòng bàn chân vào bên trong đùi hoặc bắp chân của chân đứng.',
    'Đưa hai tay lên trời, lòng bàn tay chắp lại với nhau.',
    'Giữ tư thế này trong 30 giây đến 1 phút.',
    'Hạ chân xuống và lặp lại với chân còn lại.',
  ];

  // Danh sách các bước cho bài tập "Tư Thế Chiến Binh"
  final List<String> warriorPoseSteps = [
    'Bước một chân lên phía trước, chân kia lùi lại.',
    'Gập gối chân trước sao cho đùi song song với sàn, chân sau thẳng.',
    'Đưa hai tay lên trời, lòng bàn tay hướng vào nhau.',
    'Giữ tư thế trong 30 giây đến 1 phút.',
    'Đổi bên và lặp lại.',
  ];

  // Danh sách các bước cho bài tập "Tư Thế Cầu"
  final List<String> bridgePoseSteps = [
    'Nằm ngửa, gập gối, đặt chân sát mông.',
    'Đặt hai tay dọc theo cơ thể, lòng bàn tay úp xuống.',
    'Nâng hông lên cao, giữ cho vai và đầu trên sàn.',
    'Giữ tư thế trong 30 giây đến 1 phút.',
    'Thả lỏng và trở lại tư thế ban đầu.',
  ];

  // Danh sách các bước cho bài tập "Tư Thế Chó Úp Mặt"
  final List<String> downwardDogPoseSteps = [
    'Bắt đầu từ tư thế quỳ gối, đặt hai tay và đầu gối xuống sàn.',
    'Nâng hông lên, duỗi thẳng chân và tay, tạo thành hình chữ V ngược.',
    'Đầu giữ giữa hai tay, lưng thẳng.',
    'Giữ tư thế trong 1 đến 3 phút.',
    'Thả lỏng và trở lại tư thế ban đầu.',
  ];

  // Danh sách các bước cho bài tập "Tư Thế Đứa Trẻ"
  final List<String> childPoseSteps = [
    'Quỳ gối, ngồi lên gót chân.',
    'Cúi người về phía trước, đặt trán xuống sàn.',
    'Đặt hai tay duỗi thẳng trước mặt hoặc dọc theo cơ thể.',
    'Thả lỏng toàn bộ cơ thể và thở đều.',
    'Giữ tư thế trong 1 đến 3 phút.',
  ];

  // URL của video hướng dẫn
  final String treePoseVideoUrl = 'https://www.youtube.com/shorts/w4u1W0Up6Fc';
  final String warriorPoseVideoUrl = 'https://www.youtube.com/watch?v=zt_wxsoMZaU';
  final String bridgePoseVideoUrl = 'https://www.youtube.com/shorts/zCxeTBGSzPI';
  final String downwardDogPoseVideoUrl = 'https://www.youtube.com/watch?v=lIcl6weTvYc';
  final String childPoseVideoUrl = 'https://www.youtube.com/watch?v=K547tSdJX_Y';

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
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

    if (exercise == 'Tư thế Cây') {
      steps = treePoseSteps;
      videoUrl = treePoseVideoUrl;
    } else if (exercise == 'Tư thế Chiến binh') {
      steps = warriorPoseSteps;
      videoUrl = warriorPoseVideoUrl;
    } else if (exercise == 'Tư thế Cầu') {
      steps = bridgePoseSteps;
      videoUrl = bridgePoseVideoUrl;
    } else if (exercise == 'Tư thế Chó úp mặt') {
      steps = downwardDogPoseSteps;
      videoUrl = downwardDogPoseVideoUrl;
    } else if (exercise == 'Tư thế Đứa trẻ') {
      steps = childPoseSteps;
      videoUrl = childPoseVideoUrl;
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
        title: Text('Các Bài Tập Yoga'),
      ),
      body: ListView.builder(
        itemCount: yogaExercises.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(yogaExercises[index]),
              onTap: () {
                showExerciseDetails(yogaExercises[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

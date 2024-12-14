import 'package:dash_chat_2/dash_chat_2.dart'; // Nhập thư viện chat
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:flutter_gemini/flutter_gemini.dart'; // Nhập thư viện Gemini AI

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState(); // Tạo trạng thái cho màn hình chat
}

class _ChatScreenState extends State<ChatScreen> {
  final Gemini gemini = Gemini.instance; // Tạo một thể hiện của Gemini
  List<ChatMessage> messages = []; // Danh sách các tin nhắn trong chat
  
  bool _isLoading = false; // Trạng thái loading để tránh gửi tin nhắn nhiều lần

  // Đối tượng người dùng hiện tại
  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "John Doe", // Tên người dùng hiện tại
  );

  // Đối tượng người dùng AI
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "AI PROULTRA", // Tên người dùng AI
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini'), // Tiêu đề màn hình
      ),
      body: _buildAI(), // Xây dựng giao diện chat
    );
  }

  // Hàm để xây dựng giao diện chat
  Widget _buildAI() {
    return DashChat(
      currentUser: currentUser, // Người dùng hiện tại
      onSend: _sendMessage, // Gọi hàm gửi tin nhắn khi người dùng nhấn gửi
      messages: messages, // Danh sách tin nhắn để hiển thị
    );
  }

  // Hàm để gửi tin nhắn
  void _sendMessage(ChatMessage chatMessage) {
    if (_isLoading) return; // Không gửi nếu đang tải

    setState(() {
      _isLoading = true; // Đánh dấu trạng thái loading
      messages = [chatMessage, ...messages]; // Thêm tin nhắn mới vào danh sách
    });

    try {
      String question = chatMessage.text; // Lấy nội dung tin nhắn
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull; // Lấy tin nhắn gần nhất
        
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0); // Loại bỏ tin nhắn AI gần nhất
          String response = event.content?.parts
                  ?.fold("", (previous, current) => "$previous ${current.text}") ??
              ""; // Lấy phản hồi từ AI

          lastMessage.text += response; // Cập nhật nội dung tin nhắn

          setState(() {
            messages = [lastMessage!, ...messages]; // Cập nhật danh sách tin nhắn
            _isLoading = false; // Đánh dấu kết thúc quá trình loading
          });
        } else {
          String response = event.content?.parts
                  ?.fold("", (previous, current) => "$previous ${current.text}") ??
              ""; // Phản hồi từ AI

          ChatMessage message = ChatMessage(
            user: geminiUser, // Người dùng là AI
            createdAt: DateTime.now(), // Thời điểm tạo tin nhắn
            text: response, // Nội dung phản hồi
          );

          setState(() {
            messages = [message, ...messages]; // Cập nhật danh sách tin nhắn với phản hồi
            _isLoading = false; // Kết thúc loading
          });
        }
      });
    } catch (e) {
      print(e); // In ra lỗi nếu có
      setState(() {
        _isLoading = false; // Đánh dấu kết thúc loading
      });
    }
  }
}

import 'dart:convert'; // Nhập thư viện để xử lý JSON
import 'dart:io'; // Nhập thư viện để làm việc với File
import 'package:dacn/Model/user_model.dart'; // Nhập mô hình người dùng
import 'package:dacn/Provider/userProvider.dart'; // Nhập provider cho người dùng
import 'package:dacn/Widget/User.dart'; // Nhập widget cho người dùng
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:http/http.dart' as http; // Nhập thư viện HTTP
import 'package:image_picker/image_picker.dart'; // Nhập thư viện để chọn hình ảnh
import 'package:provider/provider.dart'; // Nhập thư viện Provider

class EditProfileScreen extends StatefulWidget {
  final User user; // Đối tượng người dùng

  const EditProfileScreen({super.key, required this.user}); // Constructor với thông tin người dùng

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState(); // Trạng thái của màn hình chỉnh sửa
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers để quản lý dữ liệu nhập vào từ TextField
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;

  final _formKey = GlobalKey<FormState>(); // Khóa cho form
  File? _image; // Đối tượng File cho ảnh
  bool _isLoading = false; // Trạng thái loading để hiển thị khi gửi dữ liệu

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với dữ liệu từ người dùng
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _genderController = TextEditingController(text: widget.user.gender);
  }

  @override
  void dispose() {
    // Giải phóng các controller khi không sử dụng
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  // Hàm để chọn hình ảnh từ thư viện
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker(); // Khởi tạo ImagePicker
    final XFile? image = await picker.pickImage(source: ImageSource.gallery); // Chọn ảnh từ thư viện
    if (image != null) {
      setState(() {
        _image = File(image.path); // Lưu đường dẫn ảnh
      });
    } else {
      // Hiển thị thông báo nếu chưa chọn ảnh
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa chọn ảnh.')),
      );
    }
  }

  // Hàm để gửi dữ liệu lên server
  Future<void> _putProfile() async {
    setState(() {
      _isLoading = true; // Đánh dấu trạng thái loading
    });

    try {
      // Nếu form không hợp lệ, thoát khỏi hàm
      if (!_formKey.currentState!.validate()) {
        return; 
      }

      final userToken = Provider.of<UserProvider>(context, listen: false).token; // Lấy token người dùng từ Provider
      const requestUrl = 'http://192.168.1.7:8080/api/users/me'; // Địa chỉ API để cập nhật thông tin người dùng
      
      var request = http.MultipartRequest('PUT', Uri.parse(requestUrl)); // Tạo yêu cầu PUT
      request.headers['Authorization'] = 'Bearer $userToken'; // Thêm header xác thực

      // Thêm các trường dữ liệu vào yêu cầu
      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone'] = _phoneController.text;
      request.fields['address'] = _addressController.text;
      request.fields['gender'] = _genderController.text;

      // Kiểm tra nếu có hình ảnh đã chọn để thêm vào yêu cầu
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          filename: _image!.path.split('/').last // Lấy tên file
        ));
      }

      final streamedResponse = await request.send(); // Gửi yêu cầu
      final response = await http.Response.fromStream(streamedResponse); // Nhận phản hồi từ server

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thông tin thành công')),
        );
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Đã có lỗi xảy ra'; // Lấy thông điệp lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      print('Error: $e'); // In lỗi ra console để kiểm tra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thông tin thất bại: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Kết thúc trạng thái loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh Sửa Thông Tin'), // Tiêu đề cho AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding cho body
        child: Form(
          key: _formKey, // Gán khóa cho form
          child: ListView(
            children: [
              // Hiển thị hình ảnh đã chọn nếu có
              if (_image != null) 
                Container(
                  width: 100.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(_image!), // Hiển thị hình ảnh từ File
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              else
                const Icon(Icons.person, size: 100), // Hiển thị biểu tượng mặc định

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage, // Gọi hàm chọn hình ảnh
                child: const Text('Chọn ảnh từ thư mục'), // Nút chọn ảnh
              ),
              
              // Các trường nhập liệu cho thông tin người dùng
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ Tên', // Nhãn cho trường họ tên
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ tên'; // Kiểm tra hợp lệ
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true, // Không cho phép nhập liệu
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email', // Nhãn cho trường email
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email'; // Kiểm tra hợp lệ
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Số Điện Thoại', // Nhãn cho trường số điện thoại
                  icon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Địa Chỉ', // Nhãn cho trường địa chỉ
                  icon: Icon(Icons.home),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(
                  labelText: 'Giới tính', // Nhãn cho trường giới tính
                  icon: Icon(Icons.man),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _putProfile, // Vô hiệu hóa nút khi đang tải
                child: _isLoading 
                  ? const CircularProgressIndicator() // Hiển thị đèn loading
                  : const Text('Lưu Thay Đổi'), // Nút lưu thay đổi
              ),
            ],
          ),
        ),
      ),
    );
  }
}

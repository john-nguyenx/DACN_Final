
class StepData {
  late final int currentSteps; // Số bước hiện tại
  late final int caloriesBurned; // Số calo đã tiêu tốn

  StepData({
    required this.currentSteps,
    required this.caloriesBurned,
  });

  // Phương thức tạo đối tượng từ JSON
  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
      currentSteps: json['currentSteps'],
      caloriesBurned: json['caloriesBurned'],
    );
  }

  // Phương thức chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'currentSteps': currentSteps,
      'caloriesBurned': caloriesBurned,
    };
  }

  StepData copyWith({
    int? currentSteps,
    int? caloriesBurned,
  }) {
    return StepData(
      currentSteps: currentSteps ?? this.currentSteps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
    );
  }
}
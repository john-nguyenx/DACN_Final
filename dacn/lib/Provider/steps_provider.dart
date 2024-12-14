import 'package:flutter/foundation.dart'; // Import to use ChangeNotifier

// Model for the steps data
class StepsData {
  int currentSteps; // Current step count
  double caloriesBurned; // Calories burned based on current steps

  // Default constructor
  StepsData({
    this.currentSteps = 0,
    this.caloriesBurned = 0.0,
  });
}

// Provider to manage step data and notify listeners of changes
class StepsProvider with ChangeNotifier {
  StepsData _stepData = StepsData(); // Variable to hold current step data
  List<int> _weeklySteps = List.filled(7, 0); // Store steps data for the last 7 days

  // Getter to access current step data
  StepsData get stepData => _stepData;

  // Getter for accessing weekly steps
  List<int> get weeklySteps => _weeklySteps;

  // Getter to calculate calories burned based on today's steps
  double get caloriesBurned => _stepData.currentSteps * 0.04; // Assuming 0.04 calories per step

  // Update steps and calculate burned calories
  void updateSteps(int newSteps) {
    _stepData.currentSteps = newSteps; // Update current step count
    // Calculate calories burned
    _stepData.caloriesBurned = newSteps * 0.04;
    notifyListeners(); // Notify listeners of the change
  }

  // Reset steps to the initial state
  void resetSteps() {
    _stepData = StepsData(); // Reset to default steps data
    notifyListeners(); // Notify listeners of the change
  }

  // Set steps for a specific day (index) for loading data
  void setStepsForDay(int dayIndex, int steps) {
    if (dayIndex >= 0 && dayIndex < _weeklySteps.length) {
      _weeklySteps[dayIndex] = steps; // Set steps for the specific day
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Load weekly step data (this method should be called during initialization)
  void loadWeeklySteps(List<int> stepsData) {
    if (stepsData.length == 7) {
      _weeklySteps = stepsData; // Assuming you have data for 7 days
      notifyListeners(); // Notify listeners of the change
    }
  }
}

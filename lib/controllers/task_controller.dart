import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  var filteredTaskList = <Task>[].obs;
  var filterOption = 'All'.obs;
  var titleError = ''.obs;
  var descriptionError = ''.obs;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    searchQuery.listen((query) => filterTasks(query));
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void filterTasks(String query) {
    filteredTaskList.value = taskList
        .where((task) =>
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void deleteTask(Task task) {
    taskList.remove(task);
    saveTasks();
    filterTasks(searchQuery.value);
  }

  void toggleCompletion(Task task, bool isCompleted) {
    int index = taskList.indexOf(task);
    if (index != -1) {
      taskList[index].isCompleted = isCompleted;
      taskList.refresh();
      _saveTasks();
      filterTasks(searchQuery.value);
    }
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      List<dynamic> taskListJson = jsonDecode(tasksJson);
      taskList.value =
          taskListJson.map((taskData) => Task.fromJson(taskData)).toList();
      filterTasks(searchQuery.value);
    }
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksJson =
        jsonEncode(taskList.map((task) => task.toJson()).toList());
    prefs.setString('tasks', tasksJson);
  }

  List<Task> get filteredTasks {
    switch (filterOption.value) {
      case 'Completed':
        return filteredTaskList.where((task) => task.isCompleted).toList();
      case 'Incomplete':
        return filteredTaskList.where((task) => !task.isCompleted).toList();
      case 'Recently':
        return filteredTaskList
            .where((task) => task.createdAt.isAfter(
                  DateTime.now().subtract(const Duration(days: 7)),
                ))
            .toList();
      default:
        return filteredTaskList;
    }
  }

  Map<String, List<Task>> get tasksGroupedByDate {
    Map<String, List<Task>> groupedTasks = {};
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    for (var task in filteredTaskList) {
      String dateKey;
      if (_isSameDate(task.createdAt, today)) {
        dateKey = 'Today';
      } else if (_isSameDate(task.createdAt, yesterday)) {
        dateKey = 'Yesterday';
      } else {
        dateKey = DateFormat('d MMMM, yyyy').format(task.createdAt);
      }

      groupedTasks[dateKey] = (groupedTasks[dateKey] ?? [])..add(task);
    }

    var sortedKeys = groupedTasks.keys.toList();
    sortedKeys.sort((a, b) {
      if (a == 'Today') return -1;
      if (b == 'Today') return 1;
      return a.compareTo(b);
    });

    Map<String, List<Task>> sortedGroupedTasks = {};
    for (var key in sortedKeys) {
      sortedGroupedTasks[key] = groupedTasks[key]!;
    }

    return sortedGroupedTasks;
  }

  void addTask(String title, String description) {
    if (title.isNotEmpty && description.isNotEmpty) {
      Task newTask = Task(
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      taskList.add(newTask);
      saveTasks();
      filterTasks(searchQuery.value);

      titleError.value = '';
      descriptionError.value = '';

      Get.back();
    } else {
      if (title.isEmpty) {
        titleError.value = 'Title is required';
      } else {
        titleError.value = '';
      }

      if (description.isEmpty) {
        descriptionError.value = 'Description is required';
      } else {
        descriptionError.value = '';
      }
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;

  List<Task> get getFilteredTasks {
    switch (filterOption.value) {
      case 'Completed':
        return filteredTaskList.where((task) => task.isCompleted).toList();
      case 'Incomplete':
        return filteredTaskList.where((task) => !task.isCompleted).toList();
      case 'Recently':
        return filteredTaskList
            .where((task) => task.createdAt.isAfter(
                  DateTime.now().subtract(const Duration(days: 7)),
                ))
            .toList();
      default:
        return filteredTaskList;
    }
  }

  void updateTaskCompletion(Task task, bool isCompleted) {
    int index = taskList.indexOf(task);
    if (index != -1) {
      taskList[index].isCompleted = isCompleted;
      _saveTasks();
      taskList.refresh();
    }
  }

  void editTask(Task task, String newTitle, String newDescription) {
    if (newTitle.isEmpty || newDescription.isEmpty) {
      if (newTitle.isEmpty) {
        titleError.value = 'Please enter the title';
      } else {
        titleError.value = '';
      }

      if (newDescription.isEmpty) {
        descriptionError.value = 'Please enter the description';
      } else {
        descriptionError.value = '';
      }
    } else {
      int index = taskList.indexOf(task);
      if (index != -1) {
        taskList[index] = Task(
          title: newTitle,
          description: newDescription,
          createdAt: DateTime.now(),
          isCompleted: task.isCompleted,
        );
        saveTasks();
        filterTasks(searchQuery.value);

        titleError.value = '';
        descriptionError.value = '';
      }
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String tasksData =
        jsonEncode(taskList.map((task) => task.toJson()).toList());
    prefs.setString('tasks', tasksData);
  }

  void setFilter(String filter) {
    filterOption.value = filter;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/navigator_controller.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../resources/color.dart';
import 'description_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskController taskController = Get.put(TaskController());

  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: TextField(
              onChanged: (query) => taskController.setSearchQuery(query),
              decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: const TextStyle(color: AppTheme.subtitleTextColor),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (taskController.tasksGroupedByDate.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No tasks added yet.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Please click on the + icon to add a new task.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: AppTheme.subtitleTextColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final tasksGrouped = taskController.tasksGroupedByDate;
              return ListView.builder(
                itemCount: tasksGrouped.length,
                itemBuilder: (context, groupIndex) {
                  String dateKey = tasksGrouped.keys.elementAt(groupIndex);
                  List<Task> tasksForDate = tasksGrouped[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Text(
                          dateKey,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...tasksForDate.map((task) => buildTaskCard(
                          context, task, screenWidth, screenHeight)),
                    ],
                  );
                },
              );
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: AppTheme.fabColor,
        child: const Icon(
          Icons.add,
          color: AppTheme.fabIconColor,
        ),
      ),
    );
  }

  Widget buildTaskCard(BuildContext context, Task task, double screenWidth,
      double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.003,
      ),
      child: Card(
        color: AppTheme.surfaceColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.040,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textColor,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.isCompleted ? 'Complete' : 'Incomplete',
                      style: TextStyle(
                        color: task.isCompleted
                            ? AppTheme.successDark
                            : AppTheme.errorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.subtitleTextColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                    onPressed: () => _showEditTaskDialog(context, task),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: AppTheme.deleteIconColor,
                    ),
                    onPressed: () => _showDeleteConfirmation(context, task),
                  ),
                  Checkbox(
                    value: task.isCompleted,
                    activeColor: AppTheme.appBarColor,
                    onChanged: (bool? value) {
                      if (value != null) {
                        taskController.toggleCompletion(task, value);
                      }
                    },
                  ),
                ],
              ),
              Text(
                DateFormat('h:mm a').format(task.createdAt),
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 3),
              ElevatedButton.icon(
                onPressed: () =>
                    _navigateToFullDescriptionScreen(context, task),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(AppTheme.primaryColor),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(4),
                ),
                label: const Text(
                  'View More',
                  style: TextStyle(
                    color: AppTheme.buttonTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: AppTheme.buttonTextColor,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFullDescriptionScreen(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullDescriptionScreen(task: task),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    taskController.titleController.clear();
    taskController.descriptionController.clear();
    taskController.titleError.value = '';
    taskController.descriptionError.value = '';

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Add Task',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppTheme.textColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => TextField(
                  controller: taskController.titleController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    errorText: taskController.titleError.value.isEmpty
                        ? null
                        : taskController.titleError.value,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.errorColor,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Obx(() => TextField(
                  controller: taskController.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    errorText: taskController.descriptionError.value.isEmpty
                        ? null
                        : taskController.descriptionError.value,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.errorColor,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.errorColor,
                      ),
                    ),
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String title = taskController.titleController.text;
              String description = taskController.descriptionController.text;

              bool isValid = true;

              if (title.isEmpty) {
                taskController.titleError.value = 'Title is required';
                isValid = false;
              } else {
                taskController.titleError.value = '';
              }

              if (description.isEmpty) {
                taskController.descriptionError.value =
                    'Description is required';
                isValid = false;
              } else {
                taskController.descriptionError.value = '';
              }

              if (isValid) {
                taskController.addTask(title, description);
                Get.back();
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
            ),
            child: const Text('Add',
                style: TextStyle(color: AppTheme.buttonTextColor)),
          )
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    taskController.titleController.text = task.title;
    taskController.descriptionController.text = task.description;

    taskController.titleError.value = '';
    taskController.descriptionError.value = '';

    Get.dialog(
      AlertDialog(
        title: const Text(
          'Update Task',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppTheme.textColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => TextField(
                  controller: taskController.titleController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    errorText: taskController.titleError.value.isEmpty
                        ? null
                        : taskController.titleError.value,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            Obx(() => TextField(
                  controller: taskController.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: AppTheme.primaryColor),
                    errorText: taskController.descriptionError.value.isEmpty
                        ? null
                        : taskController.descriptionError.value,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String title = taskController.titleController.text;
              String description = taskController.descriptionController.text;

              bool isValid = true;
              if (title.isEmpty) {
                taskController.titleError.value = 'Title is required';
                isValid = false;
              } else {
                taskController.titleError.value = '';
              }

              if (description.isEmpty) {
                taskController.descriptionError.value =
                    'Description is required';
                isValid = false;
              } else {
                taskController.descriptionError.value = '';
              }

              if (isValid) {
                taskController.editTask(task, title, description);
                Get.back();
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
            ),
            child: const Text(
              'Update',
              style: TextStyle(color: AppTheme.buttonTextColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Delete Task',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AppTheme.textColor,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: AppTheme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              taskController.deleteTask(task);
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(AppTheme.deleteIconColor),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.surfaceColor),
            ),
          ),
        ],
      ),
    );
  }
}

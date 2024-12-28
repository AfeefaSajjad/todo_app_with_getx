import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../resources/color.dart';

class FullDescriptionScreen extends StatefulWidget {
  final Task task;

  const FullDescriptionScreen({super.key, required this.task});

  @override
  State<FullDescriptionScreen> createState() => _FullDescriptionScreenState();
}

class _FullDescriptionScreenState extends State<FullDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    void showEditTaskDialog(BuildContext context, Task task) {
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
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
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

    void showDeleteConfirmation(BuildContext context, Task task) {
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
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: AppTheme.buttonTextColor),
              ),
            ),
          ],
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => showEditTaskDialog(context, widget.task),
                    color: AppTheme.primaryColor,
                    tooltip: 'Update Task',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        showDeleteConfirmation(context, widget.task),
                    color: AppTheme.deleteIconColor,
                    tooltip: 'Delete Task',
                  ),
                  Checkbox(
                    value: widget.task.isCompleted,
                    activeColor: AppTheme.appBarColor,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          taskController.toggleCompletion(widget.task, value);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: widget.task.isCompleted
                          ? AppTheme.primaryColor
                          : AppTheme.textColor,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    softWrap: true,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.task.isCompleted
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.task.isCompleted ? 'Complete' : 'Incomplete',
                    style: TextStyle(
                      color: widget.task.isCompleted
                          ? AppTheme.successDark
                          : AppTheme.errorDark,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Created at: ${DateFormat('yMMMd').add_jm().format(DateTime.now())}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppTheme.appBarColor),
            Text(
              widget.task.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.subtitleTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

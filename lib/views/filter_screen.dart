import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/navigator_controller.dart';
import '../controllers/task_controller.dart';
import '../resources/color.dart';
import 'description_screen.dart';

class FilteredTaskScreen extends StatefulWidget {
  const FilteredTaskScreen({super.key});

  @override
  State<FilteredTaskScreen> createState() => _FilteredTaskScreenState();
}

class _FilteredTaskScreenState extends State<FilteredTaskScreen> {
  final TaskController taskController = Get.put(TaskController());
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              onChanged: (query) {
                taskController.setSearchQuery(query);
              },
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
                fillColor: AppTheme.surfaceColor,
              ),
            ),
          ),


          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: ['All', 'Recently', 'Incomplete', 'Completed']
                        .map((filter) {
                      return Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.02),
                        child: FilterChip(
                          label: Text(
                            filter,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: taskController.filterOption.value == filter
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                            ),
                          ),
                          selected: taskController.filterOption.value == filter,
                          selectedColor: AppTheme.primaryColor,
                          backgroundColor: Colors.white,
                          onSelected: (selected) {
                            if (selected) {
                              taskController.setFilter(filter);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ),

          Expanded(
            child: Obx(() {
              final filteredTasks = taskController.filteredTasks;
              if (filteredTasks.isEmpty) {
                return const Center(
                  child: Text(
                    "No tasks found",
                    style: TextStyle(color: AppTheme.subtitleTextColor),
                  ),
                );
              }
              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.description),
                        Text(
                          '${DateFormat('d MMMM, yyyy').format(task.createdAt)} ${DateFormat('h:mm a').format(task.createdAt)}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      activeColor: AppTheme.appBarColor,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            taskController.toggleCompletion(task, value);
                          });
                        }
                      },
                    ),
                    onTap: () {
                      Get.to(() => FullDescriptionScreen(task: task));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

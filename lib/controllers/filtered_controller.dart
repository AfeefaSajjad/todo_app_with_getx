import 'package:get/get.dart';

import '../models/task_model.dart';

class FilteredTaskController extends GetxController {
  var allTasks = <Task>[].obs;
  var searchQuery = ''.obs;
  var filterOption = 'All'.obs;

  List<Task> get filteredTasks {
    var filtered = allTasks.where((task) {
      return task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();

    switch (filterOption.value) {
      case 'Recently':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Incomplete':
        filtered = filtered.where((task) => !task.isCompleted).toList();
        break;
      case 'Completed':
        filtered = filtered.where((task) => task.isCompleted).toList();
        break;
      default:
        break;
    }

    return filtered;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilter(String filter) {
    filterOption.value = filter;
  }

  void updateTaskCompletion(Task task, bool isCompleted) {
    int index = allTasks.indexOf(task);
    if (index != -1) {
      allTasks[index].isCompleted = isCompleted;
      allTasks.refresh();
    }
  }

  void loadTasks(List<Task> tasks) {
    allTasks.assignAll(tasks);
    //  allTasks.refresh();
  }
}

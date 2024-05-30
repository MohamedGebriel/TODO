import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit/cubit.dart';
import '../../cubit/cubit/states.dart';

class TaskModel {
  String title;
  String time;
  String date;

  TaskModel({
    required this.title,
    required this.time,
    required this.date,
  });
}

class NewTasksScreen extends StatelessWidget
{
   @override
  Widget build(BuildContext context)
  {
     return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildTaskItem(TodoCubit.get(context).newTasks[index], context),
          separatorBuilder: (context, index) => Divider(
            color: Colors.purple,
            thickness: 1.0,
          ),
          itemCount: TodoCubit.get(context).newTasks.length,
        );
      },
    );
  }

  Widget buildTaskItem(task, context) => GestureDetector(

    onTap: ()
    {
      TodoCubit.get(context).openBottomSheetUpdate(task);
    },
    child: Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection direction)
      {
        TodoCubit.get(context).deleteTask(task['id']);
      },
       child:Padding(
          padding: const EdgeInsets.all(16.0),
                  child:
                  Row(
                    children: [
                         CircleAvatar(
                        backgroundColor: Colors.purple,
                        radius: 40.0,
                        child: Text(
                          task['time'].toString(),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              task['date'],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          TodoCubit.get(context).updateTaskStatus(
                            id: task['id'],
                            status: 'done',
                          );
                        },
                        icon: Icon(
                          Icons.check_box,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          TodoCubit.get(context).updateTaskStatus(
                            id: task['id'],
                            status: 'archived',
                          );
                        },
                        icon: Icon(
                          Icons.archive,
                        ),
                      ),
                    ],
                  ),
                ),
  ),
       );
        }

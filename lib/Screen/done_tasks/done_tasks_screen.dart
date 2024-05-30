import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit/cubit.dart';
import '../../cubit/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return TodoCubit.get(context).doneTasks.length > 0 ? ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildTaskItem(TodoCubit.get(context).doneTasks[index], context),
          separatorBuilder: (context, index) => Divider(
            color: Colors.purple,
            thickness: 1.0,
          ),
          itemCount: TodoCubit.get(context).doneTasks.length,
        ) :
          Center(
          child:
          Text(
            'Empty Done Tasks',
          ),

        );
      },
    );
  }

  Widget buildTaskItem(task, context) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
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
              status: 'archived',
            );
          },
          icon: Icon(
            Icons.archive,
          ),
        ),
      ],
    ),
  );
}
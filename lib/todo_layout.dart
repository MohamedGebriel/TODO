import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubit/cubit/cubit.dart';
import 'cubit/cubit/states.dart';

class TodoLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  get color => Colors.red;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..openOurDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
              listener: (context, state) {
          if (state is TodoInsertTaskState) {
            Navigator.pop(context);

            titleController.clear();
            timeController.text = '';
            dateController.clear();
          }

          if (state is TodoUpdateTaskState) {
            Navigator.pop(context);

            titleController.clear();
            timeController.text = '';
            dateController.clear();
          }

          if (state is TodoBottomSheetUpdateState)
          {
            openBottomSheet(
              context: context,
              task: state.task,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.purple,
            key: scaffoldKey,
            appBar: AppBar(
             backgroundColor: Colors.purple,
              title: Text(
                TodoCubit.get(context)
                    .titles[TodoCubit.get(context).currentIndex],
              ),
            ),
            body:
            TodoCubit.get(context)
                .widgets[TodoCubit.get(context).currentIndex],
           
             floatingActionButton: FloatingActionButton(
               backgroundColor: Colors.purple,
              onPressed: () {
                openBottomSheet(
                  context: context,
                );
              },
              child:
              Icon(
                 TodoCubit.get(context).isBottomShown ? Icons.close : Icons.add,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.purple,
              currentIndex: TodoCubit.get(context).currentIndex,
              onTap: (int index) {
                TodoCubit.get(context).changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void openBottomSheet({
    context,
    task,
  }) {
    if (TodoCubit.get(context).isBottomShown) {
      Navigator.pop(context);
      TodoCubit.get(context).changeBottomVisibility(false);
    } else
    {
      if(task != null)
      {
        titleController..text = task['title'];
        timeController..text = task['time'];
        dateController..text = task['date'];
      }

      scaffoldKey.currentState!
          .showBottomSheet(
            (context) => Container(
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 40.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      labelText: 'Enter task title',
                      // prefixIcon: Icon(
                        // Icons.phone,
                       //),
                       //suffixIcon: Icon(
                        // Icons.phone,
                       //),
                    ),
                    validator: (String? text) {
                      if (text == null) return 'title can not be empty';

                      return null;
                    },
                    onChanged: (String text) {
                     // print(text);
                    },
                    onFieldSubmitted: (String text) {
                      //print(text);
                    },
                    //enabled: false,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: timeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      labelText: 'Enter task time',
                      // prefixIcon: Icon(
                      //   Icons.phone,
                      // ),
                      // suffixIcon: Icon(
                      //   Icons.phone,
                      // ),
                    ),
                    validator: (String? text) {
                      if (text == null) return 'time can not be empty';

                      return null;
                    },
                    onChanged: (String text) {
                      //print(text);
                    },
                    onFieldSubmitted: (String text) {
                      //print(text);
                    },
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        timeController.text =
                            value!.format(context).toString();
                      });
                    },
                    //enabled: false,
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      labelText: 'Enter task date',
                     // prefixIcon: Icon(
                       // Icons.phone,
                      //),
                      // suffixIcon: Icon(
                      //   Icons.phone,
                      // ),
                    ),
                    validator: (String? text) {
                      if (text!.isEmpty) return 'date can not be empty';

                      return null;
                    },
                    onChanged: (String text) {
                      //print(text);
                    },
                    onFieldSubmitted: (String text) {
                      //print(text);
                    },
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2021-07-02'),
                      ).then((value) {
                        dateController.text =
                            DateFormat.yMMMd().format(value!);
                      });
                    },
                    //enabled: false,
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.purple,
                    child: MaterialButton(
                      onPressed: () {
                        if (formKey.currentState!.validate())
                        {
                          if(task != null)
                          {
                            TodoCubit.get(context).updateTask(
                              time: timeController.text,
                              title: titleController.text,
                              date: dateController.text,
                              id: task['id'], status: '',
                            );
                          } else
                          {
                            TodoCubit.get(context).insertTask(
                              time: timeController.text,
                              title: titleController.text,
                              date: dateController.text,
                            );
                          }
                        }
                      },
                      child: Text(task != null ? 'update task'.toUpperCase() : 'Add Task'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .closed
          .then((value) {
        TodoCubit.get(context).changeBottomVisibility(false);
      });

      TodoCubit.get(context).changeBottomVisibility(true);
    }
  }
}

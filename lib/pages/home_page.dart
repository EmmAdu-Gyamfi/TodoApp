import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/todo_item_cubit.dart';
import 'package:todo_app/pages/todo_item_edit_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _selectedDate;
  TextEditingController timeInputController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  late String? todoActivityInput;
  late String? timeInput;
  late String? dateInput;
  late String? placeInput;
  late String formattedDate;
  bool showFab = true;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeInputController.text = "";
    dateInputController.text = "";
    _loadTodoItems();
  }
  var isChecked = false;
  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      // backgroundColor: Colors.redAccent,
      floatingActionButton: showFab ? FloatingActionButton.extended(
        backgroundColor: Colors.white,
          onPressed: (){

             // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
           showDialog(
              context: context,
              builder: (context) {

                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 550,
                      child: Column(
                        children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.task_alt_outlined, color: Colors.redAccent,),

                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Text("Add Activity", style: GoogleFonts.poppins(fontSize: 20, color: Colors.red)),
                             ),
                           ],
                         ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(

                                onChanged: (value){
                                  setState(() {
                                    todoActivityInput = value;

                                  });
                                },
                                decoration: InputDecoration(

                                  icon: FaIcon(FontAwesomeIcons.calendarWeek),
                                  hintText: "Eg. Get groceries...",
                                  hintStyle: GoogleFonts.poppins(),
                                  label: Text("Activity", style: GoogleFonts.poppins() ,),
                                  enabled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red
                                      )
                                  ),
                                  labelStyle: GoogleFonts.poppins(),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red
                                    )
                                  )
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(

                                onChanged: (value){
                                 setState(() {
                                   placeInput = value;
                                 });
                                },
                                decoration: InputDecoration(
                                  icon:  FaIcon(FontAwesomeIcons.locationArrow),
                                    hintText: "Eg. Supermarket...",
                                    hintStyle: GoogleFonts.poppins(),
                                    label: Text("Location", style: GoogleFonts.poppins(),),
                                    enabled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    ),
                                    labelStyle: GoogleFonts.poppins(),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                // onChanged: (value){
                                //   setState(() {
                                //     dateInput = value;
                                //   });
                                // },
                                keyboardType: TextInputType.none,
                                controller: dateInputController,
                                onTap: () async {
                                  final DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2017, 1),
                                    lastDate: DateTime(2022, 7),
                                    helpText: 'Select a date',
                                  );
                                  if (newDate != null) {
                                    _selectedDate = newDate;

                                    dateInputController
                                      ..text = DateFormat('dd MMMM, yyyy').format(
                                          _selectedDate)
                                      ..selection = TextSelection.fromPosition(
                                          TextPosition(
                                              offset: dateInputController.text.length,
                                              affinity: TextAffinity.upstream));
                                    setState(() {
                                      dateInputController.text = DateFormat('EEEE, dd MMMM, yyyy').format(
                                          _selectedDate).toString();
                                      dateInput =  DateFormat('yyyy-MM-dd').format(
                                          _selectedDate).toString();
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    icon: FaIcon(FontAwesomeIcons.calendarAlt),
                                    hintText: "Eg. 01-01-2001...",
                                    hintStyle: GoogleFonts.poppins(),
                                    label: Text("Date", style: GoogleFonts.poppins() ,),
                                    enabled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    ),
                                    labelStyle: GoogleFonts.poppins(),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                onChanged: (value){
                                  setState(() {
                                    timeInput = value
                                    ;
                                  });
                                },
                                keyboardType: TextInputType.none,
                                controller: timeInputController,
                                onTap:() async {
                                  TimeOfDay? pickedTime =  await showTimePicker(
                                    initialEntryMode: TimePickerEntryMode.input,
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );

                                  if(pickedTime != null ){
                                    print(pickedTime.format(context));   //output 10:51 PM
                                    DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                                    //converting to DateTime so that we can further format on different pattern.
                                    print(parsedTime); //output 1970-01-01 22:53:00.000
                                    String formattedTime = DateFormat('HH:mm').format(parsedTime);
                                    print(formattedTime); //output 14:59:00
                                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                                    setState(() {
                                      timeInputController.text = formattedTime; //set the value of text field.
                                      timeInput = DateFormat('HH:mm:ss').format(parsedTime);
                                    });
                                  }else{
                                    print("Time is not selected");
                                  }
                                },

                                decoration: InputDecoration(
                                    icon: Icon(Icons.alarm),
                                    hintText: "Eg. 02:15pm...",
                                    hintStyle: GoogleFonts.poppins(),
                                    label: Text("Time", style: GoogleFonts.poppins() ,),
                                    enabled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    ),
                                    labelStyle: GoogleFonts.poppins(),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))

                                    ),
                                    child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.red),)
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(

                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))

                                    ),
                                    onPressed: (){
                                      BlocProvider.of<TodoItemCubit>(context).postTodoItem(todoActivityInput!, placeInput, dateInput!+'T'+timeInput!);

                                      Navigator.pop(context);

                                      // _scaffoldKey.currentState?.showSnackBar(SnackBar(
                                      //   backgroundColor: Colors.red,
                                      //   content: Text(
                                      //     'Activity added successfully',
                                      //     style: GoogleFonts.poppins(color: Colors.white),
                                      //   ),
                                      //   duration: Duration(seconds: 2),
                                      // ));

                                      },
                                    child: Text("Add",style: GoogleFonts.poppins())
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          label: Text("Add Activity",style: GoogleFonts.poppins( fontSize: 16, color: Colors.redAccent)),
          icon: FaIcon(FontAwesomeIcons.plus, color: Colors.redAccent,)
      
      ) : null,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FaIcon(FontAwesomeIcons.tasks,size: 30),
        ),
        titleSpacing: 0.2,
        backgroundColor: Colors.red,
        title: Text("ToDo App", style: GoogleFonts.poppins( fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Positioned(
            // right: -400,
            top: 100,
            left: 350,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.2)
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -250,
            // top: -200,
            child: Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink.withOpacity(0.2)
              ),
            ),
          ),
          Positioned(
            // right: -400,
            bottom: -100,
            right: 300,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.2)
              ),
            ),
          ),
          Positioned(
            bottom: -300,
            left: -300,
            // top: -200,
            child: Container(
              width: 600,
              height: 500,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink.withOpacity(0.2)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: BlocBuilder<TodoItemCubit, TodoItemState>(builder: (context, state){
                if(state is TodoItemLoadingSucceeded){
                  var todoItems = state.todoItem;
                  return NotificationListener<UserScrollNotification>(
                    onNotification: (notification){
                      setState(() {
                        if(notification.direction == ScrollDirection.forward){
                          showFab = true;
                        } else if(notification.direction == ScrollDirection.reverse){
                          showFab = false;
                        }
                      });
                      return true;
                    },
                    child: todoItems.isEmpty ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                              height: 250,
                              width: 250,
                              color: Colors.transparent,
                              child: SvgPicture.asset('assets/Hammock.svg',)),
                        ),
                        Text("Nothing to do", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),)
                      ],
                    )

                        : ListView.builder(
                        controller: _scrollController,
                        itemCount: todoItems.length,
                        itemBuilder: (context, index){
                          if(todoItems[index].dueDate != null){
                            formattedDate = DateFormat('HH:MM MMM dd, EEE').format(
                                DateTime.tryParse(todoItems[index].dueDate.toString())as DateTime).toString();
                          }

                        return Stack(
                          children:[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: InkWell(
                                child: Container(
                                  width: double.infinity,
                                  height: 135,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                ),
                                  onTap:() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            TodoItemEditPage(
                                                todoItem: todoItems[index],))
                                    );
                                  }
                              )
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 60.0, top: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                      child: Container(
                                        width: 290,
                                        // height: 53,
                                        alignment: Alignment.topLeft,
                                        // color: Colors.pink,
                                        child: Text(todoItems[index].todoActivity, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),),
                                      ),
                                      onTap:() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                TodoItemEditPage(
                                                  todoItem: todoItems[index], ))
                                        );
                                      }
                                  ),


                                  InkWell(
                                      child: Container(
                                          width: 250,
                                          // height: 44,
                                          alignment: Alignment.topLeft,
                                          // color: Colors.pink,
                                          child: todoItems[index].place != null ?
                                          Text("location: ${todoItems[index].place.toString()}",
                                            style: GoogleFonts.poppins( fontSize: 16, color: Colors.white),
                                          ) :
                                          Text("")
                                      ),
                                      onTap:() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                TodoItemEditPage(
                                                  todoItem: todoItems[index],))
                                        );
                                      }
                                  ),


                                  InkWell(
                                      child: Container(
                                        // width: 300,
                                        // height: 35,
                                        // alignment: Alignment.centerLeft,
                                        // color: Colors.pink,
                                          child: todoItems[index].dueDate != null ?

                                          Text("Due on: $formattedDate",
                                            style: GoogleFonts.poppins( fontSize: 16, color: Colors.white),
                                          ) :
                                          Text("")
                                      ),
                                      onTap:() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                TodoItemEditPage(
                                                  todoItem: todoItems[index],))
                                        );
                                      }
                                  ),
                                ],
                              ),
                            ),

                             Padding(
                               padding: const EdgeInsets.all(16.0),
                               child: Checkbox(
                                 checkColor: Colors.red,
                                   fillColor: MaterialStateProperty.all(Colors.white),
                                   value: todoItems[index].isChecked,

                                   onChanged: (value){
                                  setState(() {
                                    todoItems[index].isChecked = value!;
                                  });
                               },

                               ),
                             ),
                            Padding(
                              padding: const EdgeInsets.only(top:80.0, left: 330 ),
                              child: InkWell(
                                child: Container(
                                  child: FaIcon(FontAwesomeIcons.trashAlt, color: Colors.white,),
                                ),
                                onTap:(){
                                  showDialog(
                                  context: context,
                                  builder: (context) {
                                  return Dialog(
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                  elevation: 16,
                                    child: Container(
                                      color: Colors.white,
                                      height: 160,
                                      width: 100,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text("Are you sure you want to delete this activity?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 16),),
                                          ),

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: ElevatedButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                                        // fixedSize: MaterialStateProperty.all(Size.fromWidth(160)),
                                                        // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))

                                                    ),
                                                    child: Text("Cancel", style: GoogleFonts.b612(color: Colors.red, fontSize: 20),)
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        // fixedSize: MaterialStateProperty.all(Size.fromWidth(160)),
                                                        // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))

                                                    ),
                                                    onPressed: (){
                                                      BlocProvider.of<TodoItemCubit>(context).deleteTodoItem(todoItems[index].todoItemId);
                                                      Navigator.pop(context);
                                                      // _scaffoldKey.currentState?.showSnackBar(SnackBar(
                                                      //   backgroundColor: Colors.red,
                                                      //   content: Text(
                                                      //     'Activity deleted successfully',
                                                      //     style: GoogleFonts.poppins(color: Colors.white),
                                                      //   ),
                                                      //   duration: Duration(seconds: 2),
                                                      // ));
                                                    },
                                                    child: Text("Delete",style: GoogleFonts.poppins(fontSize: 20))
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  );
                                  }
                                  );
                                },
                              ),
                            )
                          ]
                        );
                    }),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },)
            ),
          )
        ],
      ),
    );
  }

  void _loadTodoItems() {
    BlocProvider.of<TodoItemCubit>(context).loadTodoItem();
  }
}

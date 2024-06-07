import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/todo_item_cubit.dart';
import 'package:todo_app/data/todo_item.dart';

class TodoItemEditPage extends StatefulWidget {
  final TodoItem todoItem;

  const TodoItemEditPage({Key? key, required this.todoItem}) : super(key: key);

  @override
  _TodoItemEditPageState createState() => _TodoItemEditPageState();
}

class _TodoItemEditPageState extends State<TodoItemEditPage> {
  late DateTime _selectedDate;
  TextEditingController timeInputController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  TextEditingController placeInputController = TextEditingController();
  TextEditingController todoActivityInputController = TextEditingController();
   String? todoActivityInput;
  late String? timeInput;
  late String? dateInput;
  late String? placeInput;
  late String formattedDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoActivityInput = widget.todoItem.todoActivity;//
    placeInput = widget.todoItem.place;// Utils.getMoneyPretty(balance);
    todoActivityInputController = TextEditingController(text: todoActivityInput);
    placeInputController = TextEditingController(text: placeInput);


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // todoActivityInputController.text = widget.todoItem.todoActivity;
    // placeInputController.text = widget.todoItem.place!;
    // todoActivityInput = widget.todoItem.todoActivity;
    // placeInput = widget.todoItem.place;
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
        padding: const EdgeInsets.only(top : 12.0, left: 20.0),
        child: FaIcon(FontAwesomeIcons.edit),
        ),
        title: Text("Edit Activity"),
      ),
      body: Column(

        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: todoActivityInputController,

              // onChanged: (value){
              //   setState(() {
              //
              //   });
              // },
              decoration: InputDecoration(
                  // counterText: '${_enteredText.length.toString()} character(s)',
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller:  placeInputController,
              // onChanged: (value){
              //   setState(() {
              //     placeInput = value;
              //   });
              // },
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value){
                setState(() {
                  dateInput = value;
                });
              },
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

          Padding(
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
          Spacer(),
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
                        fixedSize: MaterialStateProperty.all(Size.fromWidth(160)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))

                    ),
                    child: Text("Cancel", style: GoogleFonts.b612(color: Colors.red, fontSize: 20),)
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size.fromWidth(160)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))

                    ),
                    onPressed: (){
                      BlocProvider.of<TodoItemCubit>(context).putTodoItem(todoActivityInputController.text, placeInputController.text, dateInput!+'T'+timeInput!,widget.todoItem.todoItemId);
                      Navigator.pop(context);
                    },
                    child: Text("Save",style: GoogleFonts.poppins(fontSize: 20))
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

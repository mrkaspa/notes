import 'package:flutter/material.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class Note {
  String title;
  String body;
  Note({this.title = "", this.body = ""});
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  int currentIndex = 0;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (notes.isEmpty) {
      notes = [Note(title: "Default")];
    }
    controller.addListener(_onControllerChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[400],
              child: ListView(
                children: getNotes(),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey[400],
              child: TextField(
                textDirection: TextDirection.ltr,
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> getNotes() {
    return notes
        .asMap()
        .entries
        .map((entry) => Container(
              color: currentIndex == entry.key
                  ? Colors.grey[600]
                  : Colors.grey[500],
              height: 50,
              child: InkWell(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          entry.value.title,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete note',
                      onPressed: () {
                        _deleteNote(entry.key);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _selectNote(entry.key);
                },
              ),
            ))
        .toList();
  }

  void _addNote() {
    setState(() {
      notes.add(Note());
      _selectNote(notes.length - 1);
    });
  }

  void _selectNote(idx) {
    setState(() {
      currentIndex = idx;
      controller.text = notes[currentIndex].body;
    });
  }

  void _deleteNote(idx) {
    setState(() {
      notes.removeAt(idx);
    });
  }

  void _onControllerChange() {
    setState(() {
      var value = controller.text;
      notes[currentIndex].body = value;
      var title = value;
      if (title.length > 10) {
        title = value.substring(0, 10);
      }
      notes[currentIndex].title = title;
    });
  }
}

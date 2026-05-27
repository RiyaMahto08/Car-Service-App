import 'package:flutter/material.dart';

void main() {
  runApp(CarServiceApp());
}

class CarServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Car Service App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: LoginPage(),
    );
  }
}

// ================= LOGIN PAGE =================

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  void login() {
    if (email.text == "admin" && password.text == "1234") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => BookingPage()));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Login")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
                        height: 150,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "AI Car Service",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 25),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: login,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text("Login", style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= BOOKING PAGE =================

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final name = TextEditingController();
  final car = TextEditingController();

  String service = "General Service";

  List<Map<String, String>> bookings = [];

  void bookService() {
    if (name.text.isEmpty || car.text.isEmpty) return;

    setState(() {
      bookings.add({
        "name": name.text,
        "car": car.text,
        "service": service,
        "date": DateTime.now().toString().substring(0, 16),
      });
    });

    name.clear();
    car.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Car Service"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1486006920555-c77dcf18193c",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                children: [
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "Customer Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: car,
                    decoration: InputDecoration(
                      labelText: "Car Model",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: service,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    items:
                        [
                              "General Service",
                              "Oil Change",
                              "Repair",
                              "Wheel Alignment",
                            ]
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => service = v!),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: bookService,
                      child: Text("Book Now"),
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Booking History",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  ...bookings.map(
                    (b) => Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.car_repair, color: Colors.white),
                        ),
                        title: Text("${b['name']} - ${b['car']}"),
                        subtitle: Text(b['service']!),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChargesPage(booking: b),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CHARGES PAGE =================

class ChargesPage extends StatelessWidget {
  final Map<String, String> booking;

  ChargesPage({required this.booking});

  int getBasePrice(String service) {
    switch (service) {
      case "General Service":
        return 2000;
      case "Oil Change":
        return 1500;
      case "Repair":
        return 3000;
      case "Wheel Alignment":
        return 2500;
      default:
        return 1000;
    }
  }

  @override
  Widget build(BuildContext context) {
    int basePrice = getBasePrice(booking['service']!);
    double gst = basePrice * 0.18;
    double total = basePrice + gst;

    return Scaffold(
      appBar: AppBar(title: Text("Service Charges")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      booking['service']!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text("Base Price: ₹$basePrice"),
                    Text("GST (18%): ₹${gst.toStringAsFixed(2)}"),
                    SizedBox(height: 10),
                    Text(
                      "Total: ₹${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SchedulePage(booking: booking),
                    ),
                  );
                },
                child: Text("Proceed to Schedule"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= SCHEDULE PAGE =================

class SchedulePage extends StatefulWidget {
  final Map<String, String> booking;

  SchedulePage({required this.booking});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  void pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void confirm() {
    if (selectedDate == null || selectedTime == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmationPage(
          booking: widget.booking,
          date: selectedDate!,
          time: selectedTime!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule Service")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: pickDate,
              icon: Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? "Select Date"
                    : selectedDate.toString().split(" ")[0],
              ),
            ),

            SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: pickTime,
              icon: Icon(Icons.access_time),
              label: Text(
                selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context),
              ),
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: confirm,
                child: Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CONFIRMATION PAGE =================

class ConfirmationPage extends StatelessWidget {
  final Map<String, String> booking;
  final DateTime date;
  final TimeOfDay time;

  ConfirmationPage({
    required this.booking,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/845/845646.png",
                  height: 100,
                ),
                SizedBox(height: 20),
                Text(
                  "Booking Confirmed!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text("${booking['service']} for ${booking['car']}"),
                Text("Date: ${date.toString().split(' ')[0]}"),
                Text("Time: ${time.format(context)}"),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AIAssistantPage()),
                    );
                  },
                  child: Text("Talk to AI Assistant 🤖"),
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text("Back to Home"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= AI ASSISTANT PAGE =================

class AIAssistantPage extends StatefulWidget {
  @override
  _AIAssistantPageState createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController messageController = TextEditingController();

  List<Map<String, String>> chat = [
    {"role": "ai", "text": "Hello 👋 I'm your AI Car Assistant!"},
  ];

  // AI Quick Prompts
  List<String> prompts = [
    "What services do you provide?",
    "How much time does servicing take?",
    "Can I cancel my booking?",
  ];

  void sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      chat.add({"role": "user", "text": text});
    });

    messageController.clear();

    String reply = getAIResponse(text);

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        chat.add({"role": "ai", "text": reply});
      });
    });
  }

  String getAIResponse(String msg) {
    msg = msg.toLowerCase();

    if (msg.contains("service")) {
      return "We provide General Service, Oil Change, Repair and Wheel Alignment 🚗";
    } else if (msg.contains("time")) {
      return "Most services take around 2-4 hours ⏱️";
    } else if (msg.contains("cancel")) {
      return "Yes, you can cancel booking before service starts.";
    } else if (msg.contains("price")) {
      return "Prices depend on selected service 💰";
    } else {
      return "Thank you! Our support team will assist you 👍";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Assistant 🤖")),
      body: Column(
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1522202176988-66273c2fd55f",
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          SizedBox(height: 10),

          Wrap(
            spacing: 10,
            children: prompts
                .map(
                  (p) => ActionChip(
                    label: Text(p),
                    onPressed: () => sendMessage(p),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: chat.map((msg) {
                bool isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepPurple : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => sendMessage(messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

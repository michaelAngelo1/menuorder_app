import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<String> menus = ["Nasi Goreng", "Buncis", "Es Teh"];
  List<int> price = [20000, 25000, 10000];
  int totalPrice = 0;
  String foodNotes = "";
  void getTotalPrice(int index, int amount) {
    totalPrice = price[index] * amount;
    notifyListeners();
  }

  void getNotes(String notes) {
    foodNotes = notes;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Returned variable state
    var appState = context.watch<MyAppState>();
    List<String> menus = appState.menus;
    List<int> prices = appState.price;

    return Scaffold(
      appBar: const buildAppBar(title: "Home"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          height: MediaQuery.of(context).size.height - 15,
          child: ListView.builder(
            itemCount: menus.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage(title: menus[index], price: prices[index], index: index)));
                },
                child: Card(
                  elevation: 1.0,
                  child: Container(
                    height: 50,
                    color: const Color.fromARGB(255, 239, 255, 246),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Text(
                            menus[index],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.transparent,
                              width: 100,
                            )
                          ),
                          Text(prices[index].toString())
                        ],
                      ),
                    )
                  ),
                ),
              );
            }
          )
        ),
      )
    );
  }
}

class OrderPage extends StatefulWidget {
  final String title;
  final int price;
  final int index;
  const OrderPage({
    Key? key, 
    required this.title,
    required this.price,
    required this.index,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late int amount;
  late String notes;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: const buildAppBar(title: "Order Food"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Menu Form Field
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500
              )
            ),
            Text(
              widget.price.toString(),
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              )
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Enter amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) => amount = int.parse(value),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Enter notes'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onChanged: (value) => notes = value,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                appState.getTotalPrice(widget.index, amount);
                appState.getNotes(notes);
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(title: widget.title)));
              },
              child: const Center(
                child: (Text("Submit")),
              ),
            )
          ]
        )
      )
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  final String title;
  const OrderDetailPage({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    int totalPrice = appState.totalPrice;
    String notes = appState.foodNotes;

    return Scaffold(
      appBar: const buildAppBar(title: "Order Summary"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              )
            ),
            const SizedBox(height: 5.0),
            Text(
              "Total price: Rp $totalPrice",
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              )
            ),
            const SizedBox(height: 10.0),
            Text(
              "Notes: $notes",
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              )
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: const Center(
                child: Text("Back"),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              }
            )
          ]
        ),
      )
    );
  }
}

class buildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const buildAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 76, 145, 70),
      title: Center(
        child: Text(title),
      )
    );
  }

  @override
   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

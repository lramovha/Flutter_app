import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        toggleTheme: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.toggleTheme, required this.isDarkMode});

  final String title;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _income = 0.0;
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expensesController = TextEditingController();

  // List to store categorized expenses
  Map<String, double> _categorizedExpenses = {};
  String _selectedCategory = 'Food'; // Default selected category

  final List<String> _expenseCategories = ['Food', 'Rent', 'Transport', 'Others'];

  double get _expenses {
    // Calculate total expenses by summing all values in the map
    return _categorizedExpenses.values.fold(0.0, (sum, item) => sum + item);
  }

  double get _total => _income - _expenses;

  void _insertIncome() {
    setState(() {
      _income = double.tryParse(_incomeController.text) ?? 0.0;
    });
  }

  void _insertExpenses() {
    double expenseAmount = double.tryParse(_expensesController.text) ?? 0.0;
    setState(() {
      if (_categorizedExpenses.containsKey(_selectedCategory)) {
        _categorizedExpenses[_selectedCategory] =
            _categorizedExpenses[_selectedCategory]! + expenseAmount;
      } else {
        _categorizedExpenses[_selectedCategory] = expenseAmount;
      }
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: (value) {
              widget.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top bar with income, expenses, and total
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.grey[300], // Light grey background for the bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between income, expenses, and total
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R${_income.toStringAsFixed(2)}', // Changed to Rand
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Expenses',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R${_expenses.toStringAsFixed(2)}', // Changed to Rand
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R${_total.toStringAsFixed(2)}', // Changed to Rand
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Section for income entry
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Income',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _incomeController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Income Amount',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.attach_money), // Icon for income
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _insertIncome,
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white), // Icon in button
                            label: const Text('Insert Income', style: TextStyle(color: Colors.white)), // Text color
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple, // Button color
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Section for expense entry
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Expenses',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _expensesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Expense Amount',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.money_off), // Icon for expense
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            items: _expenseCategories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _insertExpenses,
                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white), // Icon in button
                            label: const Text('Insert Expenses', style: TextStyle(color: Colors.white)), // Text color
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple, // Button color
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Display categorized expenses with a similar grey background
                    const Text(
                      'Expenses by Category:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ..._categorizedExpenses.entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5), // Space between items
                        padding: const EdgeInsets.all(10), // Padding inside each category box
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Similar grey background to the top bar
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        child: ListTile(
                          title: Text(entry.key),
                          trailing: Text('R${entry.value.toStringAsFixed(2)}'), // Changed to Rand
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
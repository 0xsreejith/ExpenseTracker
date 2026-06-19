import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/helpers/helper_functions.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/provider/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExpenseProvider>().readExpenses();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  // OPEN DIALOG
  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Expense Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          cancelButton(),
          saveButton(),
        ],
      ),
    );
  }

  // CANCEL BUTTON
  Widget cancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
        amountController.clear();
      },
      child: const Text("Cancel"),
    );
  }

  // SAVE BUTTON
  Widget saveButton() {
    return TextButton(
      onPressed: () async {
        if (nameController.text.trim().isNotEmpty &&
            amountController.text.trim().isNotEmpty) {
          final expense = Expense(
            name: nameController.text.trim(),
            amount: convertStringToDouble(
              amountController.text.trim(),
            ),
            date: DateTime.now(),
          );

          await context.read<ExpenseProvider>().createExpense(expense);

          nameController.clear();
          amountController.clear();

          if (mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: const Text("Save"),
    );
  }
 
 //OPEN EDIT BOX
 void openEditBox(Expense expense) {
  // Fill textfields with existing values
  nameController.text = expense.name;
  amountController.text = expense.amount.toString();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Expense Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        cancelButton(),
        updateButton(expense)
      ],
    ),
  );
}

//UPDATE SAVE BTN
Widget updateButton(Expense oldExpense) {
  return TextButton(
    onPressed: () async {
      if (nameController.text.trim().isNotEmpty &&
          amountController.text.trim().isNotEmpty) {

        Expense updatedExpense = Expense(
          name: nameController.text.trim(),
          amount: convertStringToDouble(
            amountController.text.trim(),
          ),
          date: oldExpense.date,
        );

        await context.read<ExpenseProvider>().updateExpense(
          oldExpense.id,
          updatedExpense,
        );

        nameController.clear();
        amountController.clear();

        if (mounted) {
          Navigator.pop(context);
        }
      }
    },
    child: const Text("Update"),
  );
}
 // OPEN DELET BOX
void openDeleteBox(Expense expense) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Expense"),
      content: Text(
        "Are you sure you want to delete '${expense.name}'?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await context
                .read<ExpenseProvider>()
                .deleteExpense(expense.id);

            if (mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Expense Tracker"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: openNewExpenseBox,
            child: const Icon(Icons.add),
          ),
          body: value.allExpenses.isEmpty
              ? const Center(
                  child: Text("No Expenses Added"),
                )
              : ListView.builder(
                  itemCount: value.allExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = value.allExpenses[index];

                    return ExpenseTile(
                      onEditPressed: (context)=> openEditBox(expense),
                      onDeletePressed: (context)=> openDeleteBox(expense),
                      title: expense.name, trailing: expense.amount.toString());
                  },
                ),
        );
      },
    );
  }
}
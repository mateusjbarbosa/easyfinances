import 'package:easyfinances/components/button.dart';
import 'package:easyfinances/external/sqflite_database.dart';
import 'package:easyfinances/models/transaction.dart' as transaction;
import 'package:easyfinances/utils/currency_formatter.dart';
import 'package:easyfinances/utils/currency_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final Function? callback;
  final transaction.Transaction? data;

  const TransactionForm({
    this.callback,
    this.data,
    super.key,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  transaction.TransactionType _transactionType =
      transaction.TransactionType.income;
  DateTime _transactionDate = DateTime.now();

  void _handlePrepareForm() {
    _descriptionController = TextEditingController();
    _valueController = TextEditingController();

    if (widget.data != null) {
      _descriptionController.text = widget.data!.description;
      _valueController.text = CurrencyFormatter.addFormatting(
        widget.data!.value.toString(),
      );
      _transactionType = widget.data!.type;
      _transactionDate = widget.data!.date;
    }
  }

  void _handleOpenCalendar() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child as Widget,
        );
      },
    );

    if (selectedDate == null) return;

    setState(() {
      _transactionDate = selectedDate;
    });
  }

  void _handleSaveTransaction() async {
    String value = CurrencyFormatter.removeFormatting(
      _valueController.value.text,
    );
    final newTransaction = transaction.Transaction(
      description: _descriptionController.value.text,
      type: _transactionType,
      value: double.parse(value),
      date: _transactionDate,
    );

    await SqfliteDatabase.insert("transactions", newTransaction.toMap());

    widget.callback!();
  }

  void _handleEditTransaction() async {
    String value = CurrencyFormatter.removeFormatting(
      _valueController.value.text,
    );
    final updatedTransaction = transaction.Transaction(
      description: _descriptionController.value.text,
      type: _transactionType,
      value: double.parse(value),
      date: _transactionDate,
    );

    await SqfliteDatabase.update(
      widget.data!.id!,
      "transactions",
      updatedTransaction.toMap(),
    );

    widget.callback!();
  }

  void _handleCancelTransaction() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    _handlePrepareForm();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Nova transação',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                ),
              ),
              TextField(
                controller: _valueController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter()
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Valor",
                ),
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text("Tipo"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _transactionType = transaction.TransactionType.income;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _transactionType == transaction.TransactionType.income
                              ? Colors.green
                              : Colors.grey[500],
                    ),
                    child: const Text(
                      "Entrada",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _transactionType =
                              transaction.TransactionType.expense;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _transactionType ==
                                transaction.TransactionType.expense
                            ? Colors.red
                            : Colors.grey[500],
                      ),
                      child: const Text(
                        "Saída",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Text("Data"),
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(_transactionDate),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ElevatedButton(
                      onPressed: _handleOpenCalendar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                      ),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    onPressed: () {
                      widget.data?.id == null
                          ? _handleSaveTransaction()
                          : _handleEditTransaction();
                      Navigator.pop(context);
                    },
                    text: "Salvar",
                    type: ButtonType.primary,
                  ),
                  const Spacer(),
                  Button(
                    onPressed: _handleCancelTransaction,
                    text: "Cancelar",
                    type: ButtonType.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

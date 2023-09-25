import 'package:flutter/material.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Nova transação',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Descrição",
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Valor",
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Tipo",
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Data",
                ),
              ),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {},
              ),
              ElevatedButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

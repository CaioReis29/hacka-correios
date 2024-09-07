import 'package:flutter/material.dart';
import 'package:hacka_correios/core/theme/app_colors.dart';
import 'package:hacka_correios/pages/form_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.amareloCorreios,
        title: Text('Menu', style: TextStyle(color: AppColors.azulClaro, fontSize: 27, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Selecione o tipo de serviço"),
          const SizedBox(height: 20),
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FormPage())),
                child: Card(
                  child: Container(
                    margin: const EdgeInsets.all(70),
                    child: const Text("Content"),
                  ),
                ),
              ),
              Card(
                child: Container(
                  margin: const EdgeInsets.all(70),
                  child: const Text("Content"),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.all(70),
                  child: const Text("Content"),
                ),
              ),
              Card(
                child: Container(
                  margin: const EdgeInsets.all(70),
                  child: const Text("Content"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

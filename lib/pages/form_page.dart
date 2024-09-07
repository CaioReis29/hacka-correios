import 'package:flutter/material.dart';
import 'package:hacka_correios/pages/success_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:hacka_correios/core/theme/app_colors.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _documentController = TextEditingController();
  final _deliveryDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityUfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  final _senderAddressController = TextEditingController();
  final _senderCityUfController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _senderCepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  bool _authorizeNeighbour = false;
  bool _noNeighbour = true;
  String _neighbourNumber = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.amareloCorreios,
        centerTitle: true,
        title: Text(
          'Preencha o formulário',
          style: TextStyle(color: AppColors.azulClaro, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField(_receiverController, 'Recebedor'),
                Row(
                  children: [
                    Expanded(child: _buildTextFormField(_documentController, 'Documento')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildDateFormField(_deliveryDateController, 'Data de entrega')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildNeighbourCheckbox(),
                _buildTextFormField(_addressController, 'Endereço'),
                _buildTextFormField(_cityUfController, 'Cidade / UF'),
                _buildTextFormField(_phoneController, 'Telefone'),
                _buildCepFormField('CEP', _cepFormatter),
                const SizedBox(height: 16),
                _buildTextFormField(_senderAddressController, 'Endereço do remetente'),
                _buildTextFormField(_senderCityUfController, 'Cidade / UF do remetente'),
                _buildTextFormField(_senderPhoneController, 'Telefone do remetente'),
                _buildCepFormField('CEP do remetente', _senderCepFormatter),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: 
                  isLoading
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator(color: AppColors.azulCorreios,)),
                  )
                  : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 3)).then((_) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessPage(
                              receiver: _receiverController.text,
                              document: _documentController.text,
                              deliveryDate: _deliveryDateController.text,
                              authorizeNeighbour: _authorizeNeighbour,
                              neighbourNumber: _neighbourNumber,
                              address: _addressController.text,
                              cityUf: _cityUfController.text,
                              phone: _phoneController.text,
                              cep: _cepFormatter.getMaskedText(),
                              senderAddress: _senderAddressController.text,
                              senderCityUf: _senderCityUfController.text,
                              senderPhone: _senderPhoneController.text,
                              senderCep: _senderCepFormatter.getMaskedText(),
                            ),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amareloCorreios,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Enviar',
                      style: TextStyle(color: AppColors.azulClaro, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeighbourCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Autoriza a entrega no vizinho?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Checkbox(
              value: _noNeighbour,
              onChanged: (value) {
                setState(() {
                  _noNeighbour = value ?? false;
                  _authorizeNeighbour = !_noNeighbour;
                });
              },
            ),
            const Text('Não'),
            Checkbox(
              value: _authorizeNeighbour,
              onChanged: (value) {
                setState(() {
                  _authorizeNeighbour = value ?? false;
                  _noNeighbour = !_authorizeNeighbour;
                });
              },
            ),
            const Text('Sim'),
            if (_authorizeNeighbour)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: 100,
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Número'),
                    onChanged: (value) {
                      _neighbourNumber = value;
                    },
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }


  Widget _buildTextFormField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateFormField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCepFormField(String labelText, MaskTextInputFormatter formatter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        inputFormatters: [formatter],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || value.length != 9) {
            return 'Por favor, insira um $labelText válido';
          }
          return null;
        },
      ),
    );
  }
}

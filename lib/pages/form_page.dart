import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.amareloCorreios,
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
                  child: ElevatedButton(
                    onPressed: _generatePDF,
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

  Future<void> _generatePDF() async {
  if (_formKey.currentState?.validate() ?? false) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Dados da Entrega',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildInfoRow('Recebedor:', _receiverController.text),
              _buildInfoRow('Documento:', _documentController.text),
              _buildInfoRow('Data de entrega:', _deliveryDateController.text),
              _buildInfoRow(
                'Autorização de entrega no vizinho:',
                _authorizeNeighbour ? "Sim" : "Não",
              ),
              if (_authorizeNeighbour)
                _buildInfoRow('Número do vizinho:', _neighbourNumber),
              pw.SizedBox(height: 20),
              
              pw.Text(
                'Dados do Destinatário',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildInfoRow('Endereço:', _addressController.text),
              _buildInfoRow('Cidade/UF:', _cityUfController.text),
              _buildInfoRow('Telefone:', _phoneController.text),
              _buildInfoRow('CEP:', _cepFormatter.getMaskedText()),

              pw.SizedBox(height: 20),
              pw.Text(
                'Dados do Remetente',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildInfoRow('Endereço:', _senderAddressController.text),
              _buildInfoRow('Cidade/UF do remetente:', _senderCityUfController.text),
              _buildInfoRow('Telefone do remetente:', _senderPhoneController.text),
              _buildInfoRow('CEP do remetente:', _senderCepFormatter.getMaskedText()),
            ],
          ),
        );
      },
    ));

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

pw.Widget _buildInfoRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Expanded(
          flex: 3,
          child: pw.Text(value),
        ),
      ],
    ),
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

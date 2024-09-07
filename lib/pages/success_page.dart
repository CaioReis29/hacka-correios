import 'package:flutter/material.dart';
import 'package:hacka_correios/core/theme/app_colors.dart';
import 'package:hacka_correios/pages/initial_page.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class SuccessPage extends StatefulWidget {
  final String receiver;
  final String document;
  final String deliveryDate;
  final bool authorizeNeighbour;
  final String neighbourNumber;
  final String address;
  final String cityUf;
  final String phone;
  final String cep;
  final String senderAddress;
  final String senderCityUf;
  final String senderPhone;
  final String senderCep;

  const SuccessPage({
    super.key,
    required this.receiver,
    required this.document,
    required this.deliveryDate,
    required this.authorizeNeighbour,
    required this.neighbourNumber,
    required this.address,
    required this.cityUf,
    required this.phone,
    required this.cep,
    required this.senderAddress,
    required this.senderCityUf,
    required this.senderPhone,
    required this.senderCep,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.azulClaro,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check, color: AppColors.amareloCorreios, size: 150),
            const SizedBox(height: 10),
            Text(
              "Informações enviadadas com sucesso!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.amareloCorreios,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Pronto, agora é só aguardar seu nome ser chamado.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.amareloCorreios,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: _generatePDF,
              child: Text('Gerar Etiqueta e encerrar', style: TextStyle(color: AppColors.azulCorreios, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Text(
                    'DECLARAÇÃO DE CONTEÚDO',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Text(
                          'REMETENTE',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Text(
                          'DESTINATÁRIO',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildRemetenteColumn(),
                      _buildDestinatarioColumn(),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InitialPage()));
  }

  pw.Widget _buildRemetenteColumn() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildTableCell('Nome', widget.receiver),
        _buildTableCell('Endereço', widget.senderAddress),
        _buildTableCell('Cidade/UF', widget.senderCityUf),
        _buildTableCell('Telefone', widget.senderPhone),
        _buildTableCell('CEP', widget.senderCep),
      ],
    );
  }

  pw.Widget _buildDestinatarioColumn() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildTableCell('Nome', widget.receiver),
        _buildTableCell('Endereço', widget.address),
        _buildTableCell('Cidade/UF', widget.cityUf),
        _buildTableCell('Telefone', widget.phone),
        _buildTableCell('CEP', widget.cep),
      ],
    );
  }

  pw.Widget _buildTableCell(String label, String value) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 1, color: PdfColors.black),
        ),
      ),
      padding: const pw.EdgeInsets.all(4),
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }
}

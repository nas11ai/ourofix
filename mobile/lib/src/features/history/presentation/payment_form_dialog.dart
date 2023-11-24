import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/features/home/data/order_repository.dart';

class PaymentFormDialog extends StatefulWidget {
  final String orderId;

  const PaymentFormDialog({super.key, required this.orderId});

  @override
  _PaymentFormDialogState createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<PaymentFormDialog> {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController orderIdController = TextEditingController();
  final TextEditingController grossAmountController = TextEditingController();
  String selectedBank = 'bri'; // Default selected bank

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Form Bayar'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedBank,
              onChanged: (String? value) {
                setState(() {
                  selectedBank = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'bri',
                  child: Text('BRI'),
                ),
                DropdownMenuItem(
                  value: 'permata',
                  child: Text('Permata'),
                ),
                // Add more banks as needed
              ],
              decoration: const InputDecoration(labelText: 'Bank'),
            ),
            TextFormField(
              controller: recipientController,
              decoration: const InputDecoration(labelText: 'Nomor Rekening'),
            ),
            TextFormField(
              controller: grossAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Uang'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            final Map<String, dynamic> requestBody = {
              "payment_type": "bank_transfer",
              "bank_transfer": {
                "bank": selectedBank,
                selectedBank: {"recipient_name": recipientController.text}
              },
              "transaction_details": {
                "order_id": widget.orderId,
                "gross_amount": int.parse(grossAmountController.text),
              },
              "nama": "Anandi", // Change nama value as needed
            };

            final navigator = Navigator.of(context);
            final scaffoldMessenger = ScaffoldMessenger.of(context);

            try {
              // Menampilkan indikator loading
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Melakukan transaksi...'),
                    ],
                  ),
                ),
              );

              // Memanggil fungsi untuk submit transaksi
              await submitTransaction(requestBody);

              // Menampilkan snackbar berhasil
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Pembayaran berhasil!'),
                  backgroundColor: Colors.green,
                ),
              );

              // Menutup halaman
              navigator.pop();
            } catch (e) {
              // Menampilkan snackbar error
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Error dalam membuat transaksi: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            } finally {
              // Menyembunyikan indikator loading
              scaffoldMessenger.hideCurrentSnackBar();
            }
          },
          child: const Text('Bayar'),
        ),
      ],
    );
  }
}

Future<void> submitTransaction(Map<String, dynamic> requestBody) async {
  final repository = OrderRepository(Dio());
  await repository.submitTransaction(requestBody: requestBody);
}

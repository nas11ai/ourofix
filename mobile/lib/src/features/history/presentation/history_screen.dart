import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/history/presentation/payment_form_dialog.dart';
import 'package:mobile/src/features/home/data/order_repository.dart';
import 'package:mobile/src/features/home/domain/order.dart';
import 'package:mobile/src/routing/app_router.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Belum Dibayar'),
              Tab(text: 'Sudah Lunas'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications,
                  color: ThemeColor.tertiaryColor),
              onPressed: () {
                if (context.mounted) {
                  context.goNamed(AppRoute.notification.name);
                }
              },
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: TabBarView(
            children: [
              ServiceHistoryTab(isPaid: false),
              ServiceHistoryTab(isPaid: true),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceHistoryTab extends ConsumerWidget {
  final bool isPaid;

  const ServiceHistoryTab({Key? key, required this.isPaid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<Orders> getOrderData(BuildContext context) async {
      final repository = OrderRepository(Dio());

      var token =
          await ref.read(firebaseAuthProvider).currentUser?.getIdToken(true);

      if (token == null) {
        final idTokenResult = await ref
            .read(firebaseAuthProvider)
            .currentUser
            ?.getIdTokenResult(true);

        token = idTokenResult?.token;
      }

      try {
        final tes = await repository.getAllOrders(
          authorizationHeader: 'Bearer $token',
        );
        return tes;
      } catch (error) {
        throw Exception('Failed to load order data: $error');
      }
    }

    return FutureBuilder<Orders>(
      future: getOrderData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final Orders? orders = snapshot.data;

          if (orders?.orders.isEmpty ?? true) {
            return const Center(
              child: Text('No data available'),
            );
          }

          final filteredOrders = isPaid
              ? orders!.orders
                  .where((order) => order.statusTransaksi == 'success')
                  .toList()
              : orders!.orders
                  .where((order) => order.statusTransaksi != 'success')
                  .toList();

          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: filteredOrders.length,
            itemBuilder: (BuildContext context, int index) {
              final order = filteredOrders[index];
              final bool isOrderCompleted = order.status == 'Selesai';
              final bool isPaymentButtonVisible =
                  isOrderCompleted && (order.statusTransaksi != 'success');
              return ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      getDeviceIcon(order.deviceType.name),
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
                title: Text(order.id),
                subtitle: Text(
                  order.status,
                  style: TextStyle(
                    color: getStatusBackgroundColor(order.status),
                  ),
                ),
                trailing: isPaymentButtonVisible
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                              color: ThemeColor.secondaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.105,
                            height: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(
                              child: Text(
                                'Bayar',
                                style:
                                    TextStyle(color: ThemeColor.primaryColor),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PaymentFormDialog(
                                orderId: order.id,
                              );
                            },
                          );
                        },
                      )
                    : null,
              );
            },
          );
        }
      },
    );
  }

  Color getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Sedang diperbaiki':
        return Colors.blue;
      case 'Sedang dalam antrian':
        return Colors.amber;
      default:
        return Colors.transparent;
    }
  }

  IconData getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case 'Laptop':
        return Icons.laptop;
      case 'HP':
        return Icons.phone_android;
      case 'PV':
        return Icons.desktop_mac_sharp;
      default:
        return Icons.device_unknown;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/routing/app_router.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

class ServiceHistoryTab extends StatelessWidget {
  final bool isPaid;

  const ServiceHistoryTab({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk daftar servis
    final List<ServiceItem> services = [
      ServiceItem('ASUS TUF Gaming F15', 'Selesai', DeviceType.laptop),
      ServiceItem('Redmi Note 9', 'Sedang diperbaiki', DeviceType.phone),
      ServiceItem('Servis PC', 'Sedang dalam antrian', DeviceType.pc),
      ServiceItem('ROG Strix Scar 15', 'Selesai', DeviceType.laptop,
          isPaid: true),
    ];

    // Filter daftar servis sesuai dengan status pembayaran
    final filteredServices =
        services.where((service) => service.isPaid == isPaid).toList();

    return ListView.separated(
      itemCount: filteredServices.length,
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 1.0,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        final service = filteredServices[index];
        return ListTile(
          leading: Container(
            width: 48, // Lebar ikon
            height: 48, // Tinggi ikon
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black, // Warna border ikon
                width: 2.0, // Lebar border ikon
              ),
            ),
            child: Center(
              child: Icon(
                getDeviceIcon(service.deviceType),
                color: Colors.black,
                size: 32, // Ukuran ikon
              ),
            ),
          ),
          title: Text(service.deviceName),
          subtitle: Text(
            service.status,
            style: TextStyle(
              color: getStatusBackgroundColor(service.status),
            ),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: ThemeColor.secondaryColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.1,
              height: MediaQuery.sizeOf(context).width * 0.1,
              child: const Center(
                child: Text(
                  'Lihat',
                  style: TextStyle(color: ThemeColor.primaryColor),
                ),
              ),
            ),
            onPressed: () {},
          ),
        );
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
        return Colors.transparent; // Jika status tidak sesuai
    }
  }

  IconData getDeviceIcon(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.laptop:
        return Icons.laptop;
      case DeviceType.phone:
        return Icons.phone_android;
      case DeviceType.pc:
        return Icons.desktop_mac_sharp;
      default:
        return Icons.device_unknown;
    }
  }
}

class ServiceItem {
  final String deviceName;
  final String status;
  final DeviceType deviceType;
  final bool isPaid;

  ServiceItem(this.deviceName, this.status, this.deviceType,
      {this.isPaid = false});
}

enum DeviceType { laptop, phone, pc }

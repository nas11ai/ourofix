import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/common_widgets/custom_textformfield.dart';
import 'package:mobile/src/common_widgets/secondary_button.dart';
import 'package:mobile/src/constants/app_sizes.dart';
import 'package:mobile/src/constants/theme_colors.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/home/data/order_repository.dart';
import 'package:mobile/src/features/home/presentation/home_controller.dart';

const List<Map<String, String>> deviceList = [
  {'id': 'd40356cc-064f-468e-808b-a10b29a50653', 'name': 'Laptop'},
  {'id': '80e289d9-8483-4480-928a-8f9ceea96797', 'name': 'HP'},
  {'id': 'dcc3f7b3-1d05-4365-89ba-3a5ba4c0281e', 'name': 'PC'},
];

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final OrderRepository _orderRepository = OrderRepository(Dio());

  String? selectedDeviceId = deviceList.first['id'];
  final TextEditingController _keluhanController = TextEditingController();
  List<XFile> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: Container(
          margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.02,
          ),
          height: MediaQuery.of(context).size.height * 0.07,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                // Menampilkan indikator loading
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text('Mengirim pesanan...'),
                      ],
                    ),
                  ),
                );

                try {
                  // Memanggil fungsi untuk mengirim pesanan
                  await _submitOrder();

                  // Menampilkan snackbar berhasil
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Pesanan berhasil dibuat!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  if (context.mounted) {
                    // Menyembunyikan indikator loading
                    scaffoldMessenger.hideCurrentSnackBar();

                    // Membersihkan dan memperbarui tampilan navbar
                    ref.read(selectedIndexControllerProvider.notifier).clear();
                    ref
                        .read(selectedIndexControllerProvider.notifier)
                        .updateNavbarVisibility();
                    context.pop();
                  }
                } catch (e) {
                  // Menampilkan snackbar error
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Error dalam membuat pesanan: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );

                  // Menyembunyikan indikator loading
                  scaffoldMessenger.hideCurrentSnackBar();
                }
              },
              backgroundColor: ThemeColor.primaryColor,
              child: const Icon(Icons.add),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2.0),
              child: Container(
                color: ThemeColor.primaryColor,
                height: 2.0,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ThemeColor.primaryColor),
          leading: IconButton(
              onPressed: () {
                if (context.mounted) {
                  ref.read(selectedIndexControllerProvider.notifier).clear();
                  ref
                      .read(selectedIndexControllerProvider.notifier)
                      .updateNavbarVisibility();
                  context.pop();
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ThemeColor.primaryColor,
              )),
          title: const Text('Pesan'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              gapH32,
              buildImagePlaceHolder(context),
              gapH32,
              buildDropDownMenu(context),
              gapH32,
              buildTextFormField(context),
              gapH32,
              buildImagePicker(context),
            ],
          ),
        ),
      ),
    );
  }

  SecondaryButton buildImagePicker(BuildContext context) {
    return SecondaryButton(
      text: 'Pilih Foto',
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Pilih Sumber Gambar"),
              actions: <Widget>[
                TextButton(
                  child: const Text("Kamera"),
                  onPressed: () {
                    _getImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Galeri"),
                  onPressed: () {
                    _getImageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  SizedBox buildTextFormField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: CustomTextField(
        controller: _keluhanController,
        maxLines: 7,
        labelText: 'Masukkan Keluhan Anda',
        validator: (value) {
          return null;
        },
      ),
    );
  }

  DropdownMenu<String> buildDropDownMenu(BuildContext context) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width * 0.8,
      initialSelection: deviceList.first['name'],
      label: const Text(
        'Pilih Jenis Device',
        style: TextStyle(color: ThemeColor.primaryColor),
      ),
      textStyle: const TextStyle(color: ThemeColor.primaryColor),
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          selectedDeviceId =
              deviceList.firstWhere((device) => device['name'] == value)['id']!;
          print('selectedDeviceId: $selectedDeviceId');
        });
      },
      dropdownMenuEntries: deviceList
          .map<DropdownMenuEntry<String>>((Map<String, String> value) {
        return DropdownMenuEntry<String>(
          value: value['name']!,
          label: value['name']!,
        );
      }).toList(),
    );
  }

  Visibility buildImagePlaceHolder(BuildContext context) {
    return Visibility(
      replacement: getImagePlaceholder(context),
      visible: selectedImages.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: SizedBox(
          height: (selectedImages.length / 3).ceil() *
              (MediaQuery.of(context).size.height *
                  0.2), // 100 (tinggi gambar) + 8 (mainAxisSpacing)
          child: DottedBorder(
            color: ThemeColor.primaryColor,
            strokeWidth: 1,
            radius: const Radius.circular(16.0),
            child: buildImageView(),
          ),
        ),
      ),
    );
  }

  Center getImagePlaceholder(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/order.svg',
        semanticsLabel: 'Order Service Image',
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  Padding buildImageView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.only(top: 32.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Sesuaikan jumlah kolom sesuai kebutuhan
              crossAxisSpacing:
                  8.0, // Sesuaikan jarak antar kolom sesuai kebutuhan
              mainAxisSpacing:
                  8.0, // Sesuaikan jarak antar baris sesuai kebutuhan
            ),
            itemCount: selectedImages.length,
            itemBuilder: (BuildContext context, int index) {
              return Image.file(
                File(selectedImages[index].path),
                width: 100, // Sesuaikan ukuran gambar sesuai kebutuhan
                height: 100,
              );
            },
          ),
          Positioned(
            top: -16.0,
            left: 0.0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  selectedImages = [];
                });
              },
              icon: const Icon(
                Icons.close,
                color: ThemeColor.errorColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImages.add(image);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImages.add(image);
      });
    }
  }

  Future<void> _submitOrder() async {
    var token =
        await ref.read(firebaseAuthProvider).currentUser?.getIdToken(true);

    if (token == null) {
      final idTokenResult = await ref
          .read(firebaseAuthProvider)
          .currentUser
          ?.getIdTokenResult(true);

      token = idTokenResult?.token;
    }

    final String keluhan = _keluhanController.text;

    final List<MultipartFile> photos =
        await _convertImagesToMultipart(selectedImages);

    await _orderRepository.submitOrder(
      deviceTypeId: selectedDeviceId!,
      complains: keluhan,
      images: photos,
      authorizationHeader: 'Bearer $token',
    );

    print('Order submitted successfully');
  }

  Future<List<MultipartFile>> _convertImagesToMultipart(
      List<XFile> images) async {
    final List<MultipartFile> multipartFiles = [];

    for (final image in images) {
      final fileBytes = await File(image.path).readAsBytes();
      final String fileName = image.path.split('/').last;

      if (!(fileName.endsWith('.jpg') ||
          fileName.endsWith('.jpeg') ||
          fileName.endsWith('.png'))) {
        throw const FormatException('tipe file harus jpg/jpeg/png!');
      }

      final multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
        contentType: MediaType('image', fileName.split('.').last),
      );

      multipartFiles.add(multipartFile);
    }

    return multipartFiles;
  }
}

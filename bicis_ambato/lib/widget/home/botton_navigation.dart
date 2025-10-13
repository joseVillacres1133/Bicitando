// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   @override
//   _CustomBottomNavigationBarState createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   int _currentIndex = 0;

//   void _onTap(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   Future<void> _scanQRCode() async {
//     try {
      
//       final qrCode = await QrImageView(
//           data: 'This QR code has an embedded image as well',
//           version: QrVersions.auto,
//           size: 320,
//           gapless: false,
//           embeddedImage: AssetImage('assets/user.png'),
//           embeddedImageStyle: QrEmbeddedImageStyle(size: Size(80, 80)));

//       if (qrCode != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Scanned QR code: $qrCode')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error scanning QR code: $e')),
//       );
//     }
//   }

//  @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       onTap: (value) {
//         _scanQRCode();
//       },
//       items: const [
       
//         BottomNavigationBarItem(
//           icon: Icon(Icons.qr_code_2_rounded),
//           label: 'Scan QR',
//         ),
//       ],
//     );
//   }
// }

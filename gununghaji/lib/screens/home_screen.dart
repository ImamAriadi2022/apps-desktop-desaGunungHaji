import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Tambahkan ini untuk animasi Lottie

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selamat datang di Admin Gunung Haji',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Lottie.asset(
            'assets/animations/welcome.json', // Pastikan Anda memiliki file animasi Lottie di folder assets/animations
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
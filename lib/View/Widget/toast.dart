import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';


class ToastDemo extends StatelessWidget {
  const ToastDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Toast Demo")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => showToast(context, ToastificationStyle.flat),
            child: const Text("Flat"),
          ),
          ElevatedButton(
            onPressed: () => showToast(context, ToastificationStyle.fillColored),
            child: const Text("Fill Colored"),
          ),
          ElevatedButton(
            onPressed: () => showToast(context, ToastificationStyle.flatColored),
            child: const Text("Flat Colored"),
          ),
          ElevatedButton(
            onPressed: () => showToast(context, ToastificationStyle.minimal),
            child: const Text("Minimal"),
          ),
          ElevatedButton(
            onPressed: () => showToast(context, ToastificationStyle.simple),
            child: const Text("Simple"),
          ),
        ],
      ),
    );
  }
}

void showToast(BuildContext context, ToastificationStyle style) {
  toastification.show(
    context: context,
    title: const Text('Component updates available.'),
    description: const Text('Component updates available.'),
    type: ToastificationType.success,
    style: style,
    autoCloseDuration: const Duration(seconds: 3),
    showProgressBar: false,
    closeOnClick: true,
    pauseOnHover: true,
  );
}
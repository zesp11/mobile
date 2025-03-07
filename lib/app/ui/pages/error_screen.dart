import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  ErrorScreen({required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Animation for Error
          SizedBox(
            height: 150,
            width: 150,
            child: Lottie.asset(
              'lib/assets/animations/error.json', // Add your Lottie file here
              repeat: true,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              // Error Icon
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 36,
                ),
                const SizedBox(height: 8),
                // Error Text
                Text(
                  error ?? 'Something went wrong!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 4),
                // Hint to Retry
                const Text(
                  'Please try again later or check your internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                // Retry Button (only shown if onRetry is provided)
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

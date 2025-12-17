import 'package:flutter/material.dart';
import 'package:senior_circle/features/tab/tab.dart';

final TextEditingController phoneController = TextEditingController();
final TextEditingController otpController = TextEditingController();

final ValueNotifier<bool> showOtpField = ValueNotifier<bool>(false);

enum OtpStatus { idle, sent, success, error }

final ValueNotifier<OtpStatus> otpStatus = ValueNotifier<OtpStatus>(
  OtpStatus.idle,
);

class LiveChatLoginPage extends StatelessWidget {
  LiveChatLoginPage({super.key});

  final _formKey = GlobalKey<FormState>();

  void _sendOtp(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    showOtpField.value = true;
    otpStatus.value = OtpStatus.sent;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("OTP sent: 1234 (demo)")));
  }

  void _verifyOtp(BuildContext context) {
    if (otpController.text.trim() == "1234") {
      otpStatus.value = OtpStatus.success;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TabSelectorWidget()),
      );
    } else {
      otpStatus.value = OtpStatus.error;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP (Use 1234)")));
    }
  }

  Color _borderColorForStatus(OtpStatus status) {
    switch (status) {
      case OtpStatus.sent:
        return Colors.blueAccent;
      case OtpStatus.success:
        return Colors.green;
      case OtpStatus.error:
        return Colors.red;
      case OtpStatus.idle:
      default:
        return const Color.fromARGB(255, 228, 230, 231);
    }
  }

  String? _helperTextForStatus(OtpStatus status) {
    switch (status) {
      case OtpStatus.sent:
        return "OTP sent to this number";
      case OtpStatus.success:
        return "Number verified";
      case OtpStatus.error:
        return "Incorrect OTP. Try again";
      case OtpStatus.idle:
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: ValueListenableBuilder<OtpStatus>(
                valueListenable: otpStatus,
                builder: (context, status, _) {
                  final borderColor = _borderColorForStatus(status);
                  final helperText = _helperTextForStatus(status);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Center(
                        child: Text(
                          "Live Chat",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          "Login to continue",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      const Text(
                        "Phone number",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                        showCursor: true,
                        enableInteractiveSelection: false,
                        validator: (value) {
                          final v = value?.trim() ?? '';

                          if (v.isEmpty) return "Enter phone number";

                          if (!RegExp(r'^\+\d{1,15}$').hasMatch(v)) {
                            return "Enter valid format (e.g., +91, +1, +966)";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "+00 Enter phone number",

                          filled: true,
                          fillColor: Colors.white,
                          helperText: helperText,
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          helperStyle: TextStyle(
                            color: status == OtpStatus.error
                                ? Colors.red
                                : (status == OtpStatus.success
                                      ? Colors.green
                                      : Colors.grey),
                            fontSize: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: status == OtpStatus.error
                                  ? Colors.red
                                  : Colors.blueAccent,
                              width: 1.6,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: status == OtpStatus.error
                                  ? Colors.red
                                  : Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      ValueListenableBuilder<bool>(
                        valueListenable: showOtpField,
                        builder: (context, visible, _) {
                          if (!visible) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Enter OTP",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: otpController,
                                      maxLength: 4,
                                      cursorColor: Colors.black,
                                      showCursor: true,
                                      enableInteractiveSelection: false,
                                      selectionControls: null,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        hintText: "1234",
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.blueAccent,
                                            width: 1.6,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.blueAccent,
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.8,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => _verifyOtp(context),
                                    child: const Text("Verify"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      disabledBackgroundColor: Colors.green,
                                      disabledForegroundColor: Colors.white,
                                      splashFactory: NoSplash.splashFactory,
                                      shadowColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TextButton(
                                    onPressed: () {
                                      showOtpField.value = false;
                                      otpController.clear();
                                      otpStatus.value = OtpStatus.idle;
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _sendOtp(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Send OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "We will send an OTP to verify your number",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

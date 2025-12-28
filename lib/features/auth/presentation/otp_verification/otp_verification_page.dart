import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/auth/bloc/auth_bloc.dart';
import 'package:senior_circle/features/auth/presentation/create_user/create_user_page.dart';

import 'package:senior_circle/features/auth/presentation/widgets/otp_input_widget.dart';
import 'package:senior_circle/features/tab/tab.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    String enteredOtp = "";

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        /// ✅ NEW: Route to CreateUserPage
        if (state is CreateUserState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CreateUserPage()),
          );
        }

        /// Existing flow (if needed later)
        if (state is Authenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => TabSelectorWidget()),
            (_) => false,
          );
        }

        /// Error handling
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 6),

                Center(
                  child: Text(
                    "OTP sent to ${context.read<AuthBloc>().phoneNumber}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Enter OTP",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 12),

                OtpInput(length: 6, onCompleted: (otp) => enteredOtp = otp),

                const SizedBox(height: 32),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  AuthOtpSubmitted(enteredOtp),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Verify OTP",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

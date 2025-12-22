import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final Function(String) onChanged;

  const SearchTextField({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
                  onChanged: onChanged,
                  style: const TextStyle(
    color: Colors.black,      
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hint: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 0, 6),
                      child: Text(
                        'Search for rooms',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: Image.asset(
                        'assets/icons/search.png',
                        width: 10,
                        height: 10,
                      ),
                    ),

                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                    ),

                    contentPadding: const EdgeInsets.fromLTRB(4, 4, 0, 4),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 228, 230, 231),
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 228, 230, 231),
                        width: 1.2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 228, 230, 231),
                        width: 1.2,
                      ),
                    ),
                  ),
                );
  }
}

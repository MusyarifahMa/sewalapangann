import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../helpers/api_url.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> register() async {

    try {

      setState(() {
        isLoading = true;
      });

      final response =
          await ApiService.post(
        ApiUrl.register,
        {
          "username":
              nameController.text.trim(),
          "email":
              emailController.text.trim(),
          "password":
              passwordController.text.trim(),
        },
      );

      if (response["success"] == true) {

        if (mounted) {

          ScaffoldMessenger.of(context)
              .showSnackBar(
            SnackBar(
              content: Text(
                response["message"],
              ),
            ),
          );

          Navigator.pop(context);
        }

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              response["message"],
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xffDCC2E8),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(30),

          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 40),

                Container(
                  width: 120,
                  height: 120,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),

                  child: const Icon(
                    Icons.person_outline,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller:
                      nameController,

                  decoration:
                      InputDecoration(
                    hintText: "Nama",

                    filled: true,
                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      emailController,

                  decoration:
                      InputDecoration(
                    hintText: "Email",

                    filled: true,
                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller:
                      passwordController,

                  obscureText: true,

                  decoration:
                      InputDecoration(
                    hintText:
                        "Password",

                    filled: true,
                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.purple,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),

                    onPressed:
                        isLoading
                            ? null
                            : register,

                    child: isLoading
                        ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                        : const Text(
                            "DAFTAR",
                            style:
                                TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  child: const Text(
                    "Kembali ke Login",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
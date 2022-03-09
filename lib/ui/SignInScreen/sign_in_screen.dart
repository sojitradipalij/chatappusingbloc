import 'package:bloc_chatapp/ui/ChatRoomsScreen/chat_rooms_screen.dart';
import 'package:bloc_chatapp/ui/SignInScreen/bloc/sign_in_bloc.dart';
import 'package:bloc_chatapp/utils/app_utils.dart';
import 'package:bloc_chatapp/utils/center_button.dart';
import 'package:bloc_chatapp/utils/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../SignUpScreen/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: SignInBodyView(),
    );
  }
}

class SignInBodyView extends StatelessWidget {
  SignInBodyView({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignedInSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatRoomsScreen()),
                (route) => false);
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: SpinKitSpinningLines(
                color: primaryColor,
                size: 50,
              ),
            );
          } else if (state is SignInInitial) {
            return Container(
              margin: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonTextfield(
                        controller: emailController,
                        hintText: "Email",
                        emptyValidation: false,
                        validation: (value) {
                          String pattern =
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$";
                          RegExp regex = RegExp(pattern);
                          if (value == "" ||
                              !regex.hasMatch(value.toString().trim())) {
                            return "Email is not valid";
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    CommonTextfield(
                      controller: passwordController,
                      hintText: "Password",
                      isSecure: state.isSecure,
                      maxLine: 1,
                      suffixWidget: InkWell(
                        onTap: () {
                          BlocProvider.of<SignInBloc>(context)
                              .add(SetSecureUnSecurePassword());
                        },
                        child: Icon(state.isSecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CenterButton(
                        ontap: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<SignInBloc>(context).add(
                                LoginWithCredentialsPressed(
                                    email: emailController.text.trim(),
                                    password: passwordController.text));
                          }
                        },
                        text: "Sign In"),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account?",
                          style: blackRegular16,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: Text(" Register now",
                              style:
                                  blackRegular16.copyWith(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

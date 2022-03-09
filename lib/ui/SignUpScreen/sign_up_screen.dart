import 'package:bloc_chatapp/utils/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/app_utils.dart';
import '../../utils/center_button.dart';
import '../ChatRoomsScreen/chat_rooms_screen.dart';
import 'bloc/sign_up_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: SignUpBodyView(),
    );
  }
}

class SignUpBodyView extends StatelessWidget {
  SignUpBodyView({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignedUpSuccess) {
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
          } else if (state is SignUpInitial) {
            return Container(
              margin: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonTextfield(
                        controller: userNameController, hintText: "User Name"),
                    const SizedBox(
                      height: 15,
                    ),
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
                          if (value == "" || !regex.hasMatch(value)) {
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
                          BlocProvider.of<SignUpBloc>(context)
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
                            BlocProvider.of<SignUpBloc>(context).add(
                                SignUpPressed(
                                    userName: userNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text));
                          }
                        },
                        text: "Sign Up"),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: blackRegular16,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(" SignIn now",
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

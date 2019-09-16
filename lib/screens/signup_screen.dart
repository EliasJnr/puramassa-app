import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cpfcnpjController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = MaskedTextController(mask: "(00) 00000-0000");
  final _phone2Controller = MaskedTextController(mask: "(00) 00000-0000");

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _cpfcnpjController,
                      decoration:
                          InputDecoration(hintText: "CPF ou CNPJ do cliente"),
                      validator: (cpfcnpj) {
                        if (cpfcnpj.isEmpty) return "CPF/CNPJ inválido!";

                        return CPFValidator.isValid(cpfcnpj) ||
                                CNPJValidator.isValid(cpfcnpj)
                            ? null
                            : "CPF/CNPJ inválido!";
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                        controller: _nameController,
                        decoration:
                            InputDecoration(hintText: "Nome ou Razão Social"),
                        validator: (text) => text.isEmpty
                            ? "Nome/Razão Social inválido!"
                            : null),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "Email"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) => text.isEmpty || !text.contains("@")
                          ? "E-mail inválido!"
                          : null,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                        controller: _passController,
                        decoration: InputDecoration(hintText: "Senha"),
                        obscureText: true,
                        validator: (text) => text.isEmpty || text.length < 6
                            ? "Senha inválida! * min 6 dígitos "
                            : null),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                        controller: _confirmPassController,
                        decoration: InputDecoration(hintText: "Confirmar Senha"),
                        obscureText: true,
                        validator: (text) => _confirmPassController.text != _passController.text
                            ? "Senhas não coincidem!"
                            : null),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(hintText: "Endereço"),
                        obscureText: false,
                        validator: (text) =>
                            text.isEmpty ? "Endereço inválido!" : null),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                        controller: _phoneController,
                        decoration:
                            InputDecoration(hintText: "Telefone p/ contato"),
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        validator: (text) =>
                            text.isEmpty ? "Numero inválido!" : null),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                        controller: _phone2Controller,
                        decoration:
                        InputDecoration(hintText: "Outro telefone p/ contato"),
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        validator: (text) =>
                        text.isEmpty || _phoneController.text == _phone2Controller.text ? "Numero inválido!" : null),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text(
                          "Criar Conta",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> userData = {
                              "cpfcnpj": _cpfcnpjController.text,
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "address": _addressController.text,
                              "phone": _phoneController.text,
                              "phone2": _phone2Controller.text
                            };

                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail);
                          }
                        },
                      ),
                    )
                  ],
                ),
              );
          },
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso !"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário !"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}

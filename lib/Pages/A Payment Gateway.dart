import 'package:flutter/material.dart';

import '../All Functions Page/Functions.dart';
import 'AddMoneyFunction.dart';
import 'WithdrawFunction.dart';

class PaymentGatewayWidget extends StatefulWidget {
  const PaymentGatewayWidget({super.key, required this.operation, required this.balance, required this.star});
  final String operation;
  final int balance;
  final int star;

  @override
  _PaymentGatewayWidgetState createState() => _PaymentGatewayWidgetState();
}

class _PaymentGatewayWidgetState extends State<PaymentGatewayWidget> {
  @override
  void dispose() {
    // TODO: implement dispose
    didChangeDependencies();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  operationButton(String platformName) {
    return FloatingActionButton.extended(
        heroTag: 'Tag001',
        extendedPadding: const EdgeInsets.symmetric(horizontal: 200),
        isExtended: true,
        onPressed: () {
          if (widget.operation == 'Add Money') {
            nextPage(AddMoneyPaymentInfoCollection(platformName: platformName), context);
          } else {
            if (widget.star < 3) {
              showToast("Needs minimum 3 star to enable this function");
            } else {
              nextPage(WithdrawMoneyPaymentInfoCollection(balance: widget.balance, platformName: platformName, star: widget.star), context);
            }
          }
        },
        elevation: 2,
        label: Text(widget.operation, style: const TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF42BEA5));
  }

  @override
  Widget build(BuildContext context) {
    const Color color = Color(0xFF42BEA5);
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("Assets/background.png"), fit: BoxFit.fill)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              elevation: 10,
              shadowColor: Colors.black,
              centerTitle: true,
              title: const Text('Payment Options', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              backgroundColor: color,
              foregroundColor: Colors.white),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  if (widget.operation != 'Add Money') const Text("Withdraw Limit:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  if (widget.operation != 'Add Money')
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Image(image: AssetImage("Assets/WithdrawLimit.jpeg")),
                    ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        /*const Row(mainAxisSize: MainAxisSize.max, children: [
                          Icon(Icons.payment_rounded, size: 36),
                          Text('  Bkash', style: TextStyle(fontSize: 20)),
                        ]),*/
                        const Image(image: AssetImage("Assets/icons/Bkash.png")),
                        const SizedBox(height: 10),
                        operationButton("Bkash"),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        //const Row(mainAxisSize: MainAxisSize.max, children: [Icon(Icons.payment_rounded, size: 36), Text('  Nagad', style: TextStyle(fontSize: 20))]),
                        const Image(image: AssetImage("Assets/icons/Nagad.png")),
                        const SizedBox(height: 10),
                        operationButton("Nagad"),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        //const Row(mainAxisSize: MainAxisSize.max, children: [Icon(Icons.payment_rounded, size: 36), Text('  Rocket', style: TextStyle(fontSize: 20))]),
                        const Image(image: AssetImage("Assets/icons/Rocket.png")),
                        const SizedBox(height: 10),
                        operationButton("Rocket"),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        //const Row(mainAxisSize: MainAxisSize.max, children: [Icon(Icons.payment_rounded, size: 36), Text('  Upay', style: TextStyle(fontSize: 20))]),
                        const Image(image: AssetImage("Assets/icons/Upay.png")),
                        const SizedBox(height: 10),
                        operationButton("Upay"),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ///////////////////////////////////////////////  Bank  ////////////////////////////////////////////////////
                  /*
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        //const Row(
                        //    mainAxisSize: MainAxisSize.max, children: [Icon(Icons.account_balance_rounded, size: 36), Text('  Bank', style: TextStyle(fontSize: 20))]),
                        const Image(image: AssetImage("Assets/icons/Bank.png")),
                        const SizedBox(height: 10),
                        operationButton("Bank"),
                        FloatingActionButton.extended(
                            heroTag: 'Tag004',
                            extendedPadding: const EdgeInsets.symmetric(horizontal: 200),
                            isExtended: true,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Payment Details"),
                                    content: Form(
                                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Enter Amount", labelText: "Enter Amount", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Enter Transaction Number",
                                            labelText: "Enter Transaction Number",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Enter Account Number",
                                            labelText: "Enter Account Number",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            hintText: "Enter Bank Details",
                                            labelText: "Enter Enter Bank Details",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                      ),
                                    ])),
                                    actions: [TextButton(onPressed: () {}, child: const Text("Submit", style: TextStyle(fontSize: 18)))],
                                  );
                                },
                              );
                            },
                            elevation: 2,
                            label: const Text("Enter Payment Details", style: TextStyle(fontSize: 16, color: Colors.white)),
                            backgroundColor: color),
                      ]),
                    ),
                  ),
                  */
                  const SizedBox(height: 14),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

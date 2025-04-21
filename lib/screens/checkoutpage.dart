import 'package:ecommerceapp/bloc/cart_bloc.dart';
import 'package:ecommerceapp/bloc/cart_event.dart';
import 'package:ecommerceapp/bloc/cart_state.dart';
import 'package:ecommerceapp/screens/orderhistorypage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutPage extends StatefulWidget {
  final String amt;
  const CheckoutPage({super.key,required this.amt});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Razorpay _razorpay;
  late CartBloc cartBloc;

  @override
  void initState() {
    super.initState();
    cartBloc = BlocProvider.of<CartBloc>(context);

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _openCheckout();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrderHistoryPage()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment failed: ${response.message}"),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet selected: ${response.walletName}"),
    ));
  }

 void _openCheckout() {
  if (cartBloc.state is CartLoaded) {
   
  

    final options = {
      'key': 'rzp_test_FQ9f8JsJ4Yh8an',
      'amount': widget.amt, 
      'name': 'My E-commerce App',
      'description': 'Checkout Payment',
      'prefill': {
        'contact': '1234567890', 
        'email': 'user@example.com',
      },
      'theme': {
        'color': '#FF5733',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Unable to fetch cart details. Please try again."),
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 29, 55, 99),
    );
  }
}

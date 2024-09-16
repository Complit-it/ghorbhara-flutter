// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../constant.dart';

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;
//   // static const String _razorpayKey = 'rzp_test_NRUeeNsMSYtl4x';
//   static const String _razorpayKey = 'rzp_live_yNTs8q4TxSKx67';

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     // Verify the payment on the backend
//     final result = await _verifyPayment(
//       response.orderId!,
//       response.paymentId!,
//       response.signature!,
//     );

//     print(response);

//     if (result) {
//       // Payment verified successfully
//       print('Payment Success: ${response.paymentId}');
//     } else {
//       // Verification failed
//       print('Payment Verification Failed');
//     }
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     // Handle payment error
//     print('Payment Error: ${response.code} - ${response.message}');
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     // Handle external wallet
//     print('External Wallet: ${response.walletName}');
//   }

//   Future<void> _createOrder(int amount) async {
//     final response = await http.post(
//       Uri.parse('$baseURL/create-order'),
//       body: jsonEncode({'amount': amount}),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final orderData = jsonDecode(response.body);
//       _openCheckout(orderData['order_id'], orderData['amount']);
//     } else {
//       throw Exception('Failed to create order');
//     }
//   }

//   Future<bool> _verifyPayment(
//       String orderId, String paymentId, String signature) async {
//     final response = await http.post(
//       Uri.parse('$baseURL/verify-payment'),
//       body: jsonEncode({
//         'razorpay_order_id': orderId,
//         'razorpay_payment_id': paymentId,
//         'razorpay_signature': signature,
//       }),
//       headers: {'Content-Type': 'application/json'},
//     );

//     final responseData = jsonDecode(response.body);
//     return responseData['status'] == 'success';
//   }

//   void _openCheckout(String orderId, int amount) {
//     var options = {
//       'key': _razorpayKey,
//       'amount': amount,
//       'name': 'Test Payment',
//       'order_id': orderId,
//       'description': 'Test Payment',
//       'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
//       // 'external': {
//       //   'wallets': ['paytm']
//       // }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Razorpay Payment'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _createOrder(500); // Pass the amount you want to charge
//           },
//           child: Text('Pay Now'),
//         ),
//       ),
//     );
//   }
// }

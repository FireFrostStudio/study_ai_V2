import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';
import 'package:studyai_flutter_v2/resusable_components/top_elements.dart';

class GetPremiumPage extends StatefulWidget {
  const GetPremiumPage({super.key});

  @override
  State<GetPremiumPage> createState() => _GetPremiumPageState();
}

class _GetPremiumPageState extends State<GetPremiumPage> {
  @override
  String currentPrice = "";

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSubPrice();
  }

  Future<void> fetchSubPrice() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        final package = offerings.current!.availablePackages.single;
        final product = package.storeProduct;
        setState(() {
          currentPrice = product.priceString;
        });
      }
    } on PlatformException catch (e) {
      // optional error handling
      if (kDebugMode) {
        print("ERROR FETCHING OFFERINGS. ERROR: " +
            e.code +
            " Message: " +
            e.message.toString() +
            " Details: " +
            e.details.toString());
      }
    }
  }

  void initializeSubPrice() async {
    Offerings? offerings = await Purchases.getOfferings();
    final package = offerings.current!.availablePackages.single;
    final product = package.storeProduct;
    setState(() {
      currentPrice = product.priceString;
    });
  }

  void purchasePremium() async {
    Offerings? offerings = await Purchases.getOfferings();
    final package = offerings.current!.availablePackages.single;

    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      Data().initalizeSubStatus();
      if (customerInfo.entitlements.all["Premium"]!.isActive) {
        // Unlock that great "pro" content
        Navigator.pop(context);
        
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print("ERROR PURCHASING: " + e.message.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            TopElements(),
            Spacer(),
            Image.asset(
              "assets/icons/crown_icon.png",
              width: 250,
              height: 250,
            ),
            Spacer(),
            const Center(
                child: Padding(
              padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
              child: Text(
                "Get Premium and Go Beyond",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            )),
            Padding(
              padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
              child: Text(
                "Get Study AI Premium to access longer, more detailed, ad-free responses and be the first to access new features. For only " +
                    currentPrice +
                    "/ month.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () {
                  purchasePremium();
                },
                child: Container(
                  width: 300,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Go Pro",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

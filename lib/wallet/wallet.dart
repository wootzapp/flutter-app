import 'dart:async';
import 'dart:convert';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter/services.dart';

class Wallet {
   String address = "";
   String publicKey= "";
  Wallet({
    required this.address,
    required this.publicKey,
  });

  /// Create a random wallet
  ///
  /// Returns a new [Wallet] with a random private key. You can provide optional
  /// creation options with [extraEntropy] as a hex string that provides some
  /// extra entropy to the randomization.
  ///
  /// ```
  ///   final wallet = await Wallet.createRandom(extraEntropy: '0xbaadf00d');
  /// ```
  ///
  /// See original documentation
  ///   - https://docs.ethers.io/v5/api/signer/#Wallet-createRandom
  static Future<Wallet> createRandom({String? extraEntropy}) async {
    final JavascriptRuntime jsRuntime = getJavascriptRuntime();
    //  jsRuntime.evaluate('var window = global = globalThis;');
     jsRuntime.evaluate(await rootBundle.loadString('assets/cryp.js'));
     jsRuntime.evaluate(await rootBundle.loadString('assets/ethers.js'));

    final opts = extraEntropy == null
        ? null
        : jsonEncode({
            extraEntropy: extraEntropy,
          });

    final result = jsRuntime.evaluate('''
      const wallet = Wallet.createRandom($opts);
      // Return from evaluation
      JSON.stringify({
        address: wallet.address,
        publicKey: wallet.publicKey
      });
    ''');

    // print("wallet res" + result.toString());
    if (result.isError) {
      // throw JavascriptError(result.stringResult);
      // var te = result.stringResult as Wallet;
      print("walley error");
    }

    final json = jsonDecode(result.stringResult);
    return Wallet(
      address: json['address'],
      publicKey: json['publicKey'],
    );
  }
}
class JavascriptError extends Error {
  final String message;

  JavascriptError(this.message);
}
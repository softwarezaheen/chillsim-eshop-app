import "package:esim_open_source/data/services/consent_initializer.dart";
import "package:esim_open_source/presentation/views/shared/consent_dialog.dart";
import "package:flutter/material.dart";

/// Test widget to manually show consent dialog for debugging
class ConsentTestWidget extends StatelessWidget {
  const ConsentTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Consent Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await showConsentDialog(context);
              },
              child: const Text("Show Consent Dialog"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await ConsentInitializer.showConsentSettings(context);
              },
              child: const Text("Show Consent Settings"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final bool shouldShow = await ConsentInitializer.shouldShowConsentDialog();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Should show consent: $shouldShow")),
                );
              },
              child: const Text("Check Should Show Consent"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await ConsentInitializer.resetConsentDialogState();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Consent state reset")),
                );
              },
              child: const Text("Reset Consent State"),
            ),
          ],
        ),
      ),
    );
  }
}

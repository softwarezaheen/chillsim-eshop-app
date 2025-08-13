import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentSelectionBottomSheetViewModel extends BaseModel {
  PaymentSelectionBottomSheetViewModel({required this.completer});
  final Function(SheetResponse<PaymentType>) completer;

  void onCloseClick() {
    completer(
      SheetResponse<PaymentType>(),
    );
  }

  void onPaymentTypeClick(PaymentType paymentType) {
    completer(
      SheetResponse<PaymentType>(
        confirmed: true,
        data: paymentType,
      ),
    );
  }
}

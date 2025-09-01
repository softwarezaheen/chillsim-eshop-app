import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/services_bottom_sheet/services_bottom_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";

class ServicesBottomSheet extends StatelessWidget {
  const ServicesBottomSheet({
    required this.requestBase,
    required this.completer,
    super.key,
  });
  final SheetRequest<ServicesBottomRequest> requestBase;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    ServicesBottomRequest request =
        requestBase.data ?? const ServicesBottomRequest();
    return ViewModelBuilder<ServicesBottomViewModel>.reactive(
      viewModelBuilder: ServicesBottomViewModel.new,
      onViewModelReady: (ServicesBottomViewModel model) =>
          model.initializeData(),
      builder: (
        BuildContext context,
        ServicesBottomViewModel model,
        Widget? child,
      ) =>
          Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
            child: SizedBox(
              width: screenWidth,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 36,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.4,
                          child: Container(
                            width: 32,
                            height: 4,
                            decoration: ShapeDecoration(
                              color: Colors.black.withValues(alpha: 0.88),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  request.title != null || request.subtitle != null
                      ? Column(
                          children: <Widget>[
                            SizedBox(
                              width: screenWidth,
                              // color: Colors.red,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: <Widget>[
                                    request.title != null
                                        ? Text(
                                            request.title ?? "",
                                          )
                                        : const SizedBox(height: 0),
                                    request.subtitle != null
                                        ? Text(
                                            request.subtitle ?? "",
                                          )
                                        : const SizedBox(height: 0),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      : const SizedBox(height: 0),
                  (request.actions != null &&
                          (request.actions?.length ?? 0) > 0)
                      ? SizedBox(
                          width: screenWidth,
                          // color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            child: Column(
                              children: <Widget>[
                                verticalSpaceSmallMedium,
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: request.actions?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // Build your grid item widget here based on the index
                                    ServicesBottomAction? item =
                                        request.actions?[index];
                                    return GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => model.actionButtonClicked(
                                        tag: item?.tag ?? "",
                                        request: request,
                                        completer: completer,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  context.appColors.baseBlack,
                                            ),
                                            child: const Icon(
                                              size: 22,
                                              Icons.receipt_long_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "To your Business App", //item?.title ?? "", //"To your e&money",
                                              maxLines: 2,
                                              style: captionFourBoldTextStyle(
                                                context: context,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(height: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<ServicesBottomRequest>>(
          "requestBase",
          requestBase,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<MainBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}

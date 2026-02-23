import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/searchable_selection_bottom_sheet/searchable_selection_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class SearchableSelectionBottomSheetView<T> extends StatelessWidget {
  const SearchableSelectionBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<SearchableSelectionSheetRequest<T>> request;
  final Function(SheetResponse<T>) completer;

  @override
  Widget build(BuildContext context) {
    final SearchableSelectionSheetRequest<T> data = request.data!;
    
    return BaseView.bottomSheetBuilder(
      viewModel: SearchableSelectionBottomSheetViewModel<T>(
        items: data.items,
        displayTextExtractor: data.displayTextExtractor,
        completer: completer,
        currentValue: data.currentValue,
      ),
      builder: (
        BuildContext context,
        SearchableSelectionBottomSheetViewModel<T> viewModel,
        Widget? child,
        double screenHeight,
      ) {
        return PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 15,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BottomSheetCloseButton(
                onTap: () => viewModel.onCloseClick(),
              ),
              Text(
                data.title,
                style: headerThreeBoldTextStyle(
                  context: context,
                  fontColor: titleTextColor(context: context),
                ),
              ),
              verticalSpaceSmallMedium,
              MainInputField.formField(
                themeColor: themeColor,
                hintText: LocaleKeys.search.tr(),
                hintLabelStyle: captionOneNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
                controller: viewModel.searchController,
                backGroundColor: whiteBackGroundColor(context: context),
                labelStyle: bodyNormalTextStyle(
                  context: context,
                  fontColor: mainDarkTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: viewModel.filteredItems.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Text(
                            LocaleKeys.noDataAvailableYet.tr(),
                            style: bodyNormalTextStyle(
                              context: context,
                              fontColor: secondaryTextColor(context: context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: viewModel.filteredItems.length,
                          separatorBuilder: (BuildContext context, int index) => Divider(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final T item = viewModel.filteredItems[index];
                            final bool isSelected = item == data.currentValue;
                            
                            return ListTile(
                              title: Text(
                                data.displayTextExtractor(item),
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: themeColor,
                                    )
                                  : null,
                              onTap: () => viewModel.onItemSelected(item),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<SheetRequest<SearchableSelectionSheetRequest<T>>>("request", request))
    ..add(ObjectFlagProperty<Function(SheetResponse<T>)>.has("completer", completer));
  }
}

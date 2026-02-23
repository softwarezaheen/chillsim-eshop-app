import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/manage_auto_topup/manage_auto_topup_bottom_sheet_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class ManageAutoTopupBottomSheetView extends StatelessWidget {
  const ManageAutoTopupBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<ManageAutoTopupSheetRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: ManageAutoTopupBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext ctx,
        ManageAutoTopupBottomSheetViewModel viewModel,
        Widget? child,
        double screenHeight,
      ) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildHeader(ctx, viewModel),
                  if (viewModel.state.labelName != null &&
                      viewModel.state.labelName!.isNotEmpty)
                    _buildLabelRow(viewModel),
                  _buildContent(ctx, viewModel),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Header – purple background, bolt icon, ICCID, toggle
  // ---------------------------------------------------------------------------

  Widget _buildHeader(
    BuildContext context,
    ManageAutoTopupBottomSheetViewModel viewModel,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.primary_800,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title row
            Row(
              children: <Widget>[
                const Icon(Icons.bolt, color: Color(0xFFD3DC47), size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    LocaleKeys.auto_topup_badge.tr(),
                    style: const TextStyle(
                      color: Color(0xFFD3DC47),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: viewModel.close,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // "Never run out of data" + Active toggle
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    LocaleKeys.auto_topup_never_run_out.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  viewModel.state.isEnabled
                      ? LocaleKeys.auto_topup_active.tr()
                      : LocaleKeys.auto_topup_inactive.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 28,
                  child: AbsorbPointer(
                    absorbing: viewModel.state.isUpdating,
                    child: Switch.adaptive(
                      value: viewModel.state.isEnabled,
                      onChanged: (bool value) async {
                        if (!value) {
                          final bool? confirmed =
                              await showAdaptiveDialog<bool>(
                            context: context,
                            builder: (BuildContext ctx) =>
                                AlertDialog.adaptive(
                              title: Text(
                                LocaleKeys.auto_topup_confirm_disable.tr(),
                              ),
                              content: Text(
                                LocaleKeys
                                    .auto_topup_confirm_disable_description
                                    .tr(),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(false),
                                  child:
                                      Text(LocaleKeys.cancel.tr()),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(true),
                                  child: Text(
                                    LocaleKeys.auto_topup_yes_disable
                                        .tr(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirmed ?? false) {
                            unawaited(viewModel.onDisableConfirmed());
                          }
                        }
                      },
                      activeColor: const Color(0xFFD3DC47),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ICCID
            Text(
              LocaleKeys.auto_topup_iccid_serial.tr(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              viewModel.state.iccid ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // eSIM label row
  // ---------------------------------------------------------------------------

  Widget _buildLabelRow(ManageAutoTopupBottomSheetViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Text(
            viewModel.state.labelName!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Main content: warning, linked plan, status rows
  // ---------------------------------------------------------------------------

  Widget _buildContent(
    BuildContext context,
    ManageAutoTopupBottomSheetViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Warning banner (only when enabled)
          if (viewModel.state.isEnabled)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                border: Border.all(color: const Color(0xFFFFB74D)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFFF8F00),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      LocaleKeys.auto_topup_package_restriction_warning
                          .tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6D4C00),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Linked top-up plan
          if (viewModel.state.isLoadingConfig)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          else
            _buildLinkedPlan(context, viewModel),

          // Status + Trigger rows
          if (!viewModel.state.isLoadingConfig) ...<Widget>[
            const SizedBox(height: 14),
            _buildInfoRow(
              label: LocaleKeys.auto_topup_status_label.tr(),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  LocaleKeys.auto_topup_active.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow(
              label: LocaleKeys.auto_topup_trigger_point.tr(),
              trailing: Text(
                LocaleKeys.auto_topup_at_80_percent.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Linked Top-Up Plan card
  // ---------------------------------------------------------------------------

  Widget _buildLinkedPlan(
    BuildContext context,
    ManageAutoTopupBottomSheetViewModel viewModel,
  ) {
    final Map<String, dynamic>? bundleData =
        viewModel.state.config?.bundleData;

    final String bundleName = (bundleData?["bundle_name"] as String?) ??
        (bundleData?["name"] as String?) ??
        viewModel.state.bundleName ??
        "";

    final String? dataDisplay = bundleData?["gprs_limit_display"] as String?;
    final String? validityDisplay =
        bundleData?["validity_display"] as String?;
    final dynamic price = bundleData?["price"];

    final String subtitle =
        <String?>[dataDisplay, validityDisplay].whereType<String>().join(", ");

    final String? priceText = price != null
        ? "€${price is num ? price.toStringAsFixed(2) : price}"
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.auto_topup_linked_plan.tr().toUpperCase(),
          style: TextStyle(
            color: context.appColors.primary_800,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      bundleName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF8B6914),
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (priceText != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      priceText,
                      style: TextStyle(
                        color: context.appColors.primary_800,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      LocaleKeys.auto_topup_per_topup.tr(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: key / value row
  // ---------------------------------------------------------------------------

  Widget _buildInfoRow({
    required String label,
    required Widget trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing,
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SheetRequest<ManageAutoTopupSheetRequest>>("request", request));
    properties.add(ObjectFlagProperty<Function(SheetResponse<MainBottomSheetResponse>)>.has("completer", completer));
  }
}

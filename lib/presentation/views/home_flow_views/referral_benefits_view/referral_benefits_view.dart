import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/promotion/referral_progress_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/referral_benefits_view/referral_benefits_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class ReferralBenefitsView extends StatelessWidget {
  const ReferralBenefitsView({super.key});
  static const String routeName = "ReferralBenefitsView";

  @override
  Widget build(BuildContext context) {
    return BaseView<ReferralBenefitsViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<ReferralBenefitsViewModel>(),
      builder: (
        BuildContext context,
        ReferralBenefitsViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        height: double.infinity,
        child: PaddingWidget.applyPadding(
          top: 20,
          child: Column(
            children: <Widget>[
              CommonNavigationTitle(
                navigationTitle: LocaleKeys.referralBenefits_title.tr(),
                textStyle: headerThreeBoldTextStyle(
                  context: context,
                  fontColor: titleTextColor(context: context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        LocaleKeys.referralBenefits_subtitle.tr(),
                        style: headerFourNormalTextStyle(
                          context: context,
                          fontColor: secondaryTextColor(context: context),
                        ),
                      ).applyShimmer(
                        context: context,
                        enable: viewModel.applyShimmer,
                      ),
                      verticalSpaceMedium,
                      _ProgressSection(viewModel: viewModel),
                      verticalSpaceSmallMedium,
                      _RewardsCard(viewModel: viewModel),
                      verticalSpaceSmallMedium,
                      _BonusMilestonesSection(viewModel: viewModel),
                      verticalSpaceSmallMedium,
                      MainButton(
                        onPressed: viewModel.shareReferralCode,
                        themeColor: themeColor,
                        title: LocaleKeys.referralBenefits_shareLink.tr(),
                        hideShadows: true,
                        height: 55,
                        enabledTextColor: enabledMainButtonTextColor(
                          context: context,
                        ),
                        enabledBackgroundColor: enabledMainButtonColor(
                          context: context,
                        ),
                      ),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Progress bar with milestone markers
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.viewModel});
  final ReferralBenefitsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final int position = viewModel.positionInCycle;
    final int total = viewModel.cycleSize;
    final double progress = total > 0 ? position / total : 0.0;
    final List<ReferralMilestoneModel> milestones =
        viewModel.referralProgress?.milestones ?? <ReferralMilestoneModel>[];
    final double milestoneBonus = milestones.fold(
      0.0,
      (double sum, ReferralMilestoneModel m) => sum + (m.bonus ?? 0),
    );
    final double referralAmt = double.tryParse(
          viewModel.referralProgress?.referralAmount ?? '',
        ) ??
        double.tryParse(viewModel.referAndEarnAmount.split(' ').first) ??
        0.0;
    final double maxEarnable = (total * referralAmt) + milestoneBonus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ProgressBarWithMarkers(
          progress: progress,
          milestones: milestones,
          total: total,
        ),
        verticalSpaceTiny,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "$position / $total",
              style: captionOneNormalTextStyle(
                context: context,
                fontColor: secondaryTextColor(context: context),
              ),
            ),
            if (maxEarnable > 0)
              Text(
                "+€${maxEarnable.toStringAsFixed(0)} Chill Credits",
                style: captionOneBoldTextStyle(
                  context: context,
                  fontColor: sectionTitleTextColor(context: context),
                ),
              ),
          ],
        ),
      ],
    ).applyShimmer(context: context, enable: viewModel.applyShimmer);
  }
}

class _ProgressBarWithMarkers extends StatelessWidget {
  const _ProgressBarWithMarkers({
    required this.progress,
    required this.milestones,
    required this.total,
  });
  final double progress;
  final List<ReferralMilestoneModel> milestones;
  final int total;

  static const List<Color> _gradientColors = <Color>[
    Color(0xFF906BAE),
    Color(0xFFC4AECE),
    Color(0xFFE9EC9B),
    Color(0xFFD3DC47),
  ];
  static const List<double> _gradientStops = <double>[0.0, 0.35, 0.65, 1.0];
  static const double _barHeight = 28.0;
  static const double _badgeSize = 24.0;
  static const double _topPadding = _badgeSize + 8.0;

  @override
  Widget build(BuildContext context) {
    // Mid marker: first non-last milestone target, or fallback 50%
    final double midFraction = milestones.length > 1 &&
            milestones.first.target != null &&
            total > 0
        ? (milestones.first.target! / total).clamp(0.0, 1.0)
        : 0.5;
    final bool midReached =
        milestones.isNotEmpty ? milestones.first.reached == true : false;
    final bool endReached =
        milestones.isNotEmpty ? milestones.last.reached == true : false;

    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        final double totalWidth = constraints.maxWidth;
        final double fillWidth = totalWidth * progress.clamp(0.0, 1.0);
        final Color activeColor = enabledMainButtonColor(context: ctx);
        final Color inactiveColor =
            secondaryTextColor(context: ctx).withValues(alpha: 0.35);
        final Color borderColor = whiteBackGroundColor(context: ctx);

        return SizedBox(
          width: totalWidth,
          height: _topPadding + _barHeight,
          child: Stack(
            children: <Widget>[
              // Star badge — always shown at midFraction
              Positioned(
                left: (totalWidth * midFraction - _badgeSize / 2)
                    .clamp(0.0, totalWidth - _badgeSize),
                top: 0,
                child: _BadgeWidget(
                  icon: Icons.star_rounded,
                  reached: midReached,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  borderColor: borderColor,
                  size: _badgeSize,
                ),
              ),
              // Trophy badge — always shown at right edge
              Positioned(
                left: totalWidth - _badgeSize,
                top: 0,
                child: _BadgeWidget(
                  icon: Icons.emoji_events_rounded,
                  reached: endReached,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  borderColor: borderColor,
                  size: _badgeSize,
                ),
              ),
              // Bar with gradient fill + always-visible dashed line
              Positioned(
                left: 0,
                top: _topPadding,
                child: SizedBox(
                  width: totalWidth,
                  height: _barHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: totalWidth,
                          height: _barHeight,
                          color: mainBorderColor(context: ctx),
                        ),
                        ClipRect(
                          clipper: _RectClipper(fillWidth),
                          child: Container(
                            width: totalWidth,
                            height: _barHeight,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: _gradientColors,
                                stops: _gradientStops,
                              ),
                            ),
                          ),
                        ),
                        // Dashed line — always shown at midFraction
                        Positioned(
                          left: totalWidth * midFraction,
                          top: 0,
                          child: CustomPaint(
                            size: Size(2, _barHeight),
                            painter: _DashedLinePainter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeWidget extends StatelessWidget {
  const _BadgeWidget({
    required this.icon,
    required this.reached,
    required this.activeColor,
    required this.inactiveColor,
    required this.borderColor,
    required this.size,
  });
  final IconData icon;
  final bool reached;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: reached ? activeColor : inactiveColor,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(icon, size: size * 0.5, color: Colors.white),
    );
  }
}

class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar({required this.progress, super.key});
  final double progress;

  static const List<Color> _gradientColors = <Color>[
    Color(0xFF906BAE),
    Color(0xFFC4AECE),
    Color(0xFFE9EC9B),
    Color(0xFFD3DC47),
  ];
  static const List<double> _gradientStops = <double>[0.0, 0.35, 0.65, 1.0];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        final double fillWidth =
            constraints.maxWidth * progress.clamp(0.0, 1.0);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: <Widget>[
              Container(
                height: 10,
                width: constraints.maxWidth,
                color: mainBorderColor(context: ctx),
              ),
              ClipRect(
                clipper: _RectClipper(fillWidth),
                child: Container(
                  height: 10,
                  width: constraints.maxWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: _gradientColors,
                      stops: _gradientStops,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RectClipper extends CustomClipper<Rect> {
  const _RectClipper(this.width);
  final double width;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, size.height);

  @override
  bool shouldReclip(_RectClipper old) => old.width != width;
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const double dashH = 3;
    const double gapH = 2.5;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(0, (y + dashH).clamp(0, size.height)),
        paint,
      );
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}

class ClipRoundedProgressBar extends StatelessWidget {
  const ClipRoundedProgressBar({required this.progress, super.key});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: mainBorderColor(context: context),
        valueColor: AlwaysStoppedAnimation<Color>(
          enabledMainButtonColor(context: context),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Combined reward + friend reward card
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _RewardsCard extends StatelessWidget {
  const _RewardsCard({required this.viewModel});
  final ReferralBenefitsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            titleTextColor(context: context).withValues(alpha: 0.04),
            sectionTitleTextColor(context: context).withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainBorderColor(context: context)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                LocaleKeys.referralBenefits_yourRewards.tr(),
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
              ),
              Flexible(
                child: Text(
                  LocaleKeys.referralBenefits_perReferral.tr(
                    namedArgs: <String, String>{
                      "amount": viewModel.referAndEarnAmount,
                    },
                  ),
                  textAlign: TextAlign.right,
                  style: headerThreeBoldTextStyle(
                    context: context,
                    fontColor: titleTextColor(context: context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: mainBorderColor(context: context)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                LocaleKeys.referralBenefits_friendReward.tr(),
                style: captionOneNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
              ),
              Flexible(
                child: Text(
                  LocaleKeys.referralBenefits_friendDiscount.tr(
                    namedArgs: <String, String>{
                      "discount": viewModel.referredDiscountPercentage,
                    },
                  ),
                  textAlign: TextAlign.right,
                  style: headerThreeBoldTextStyle(
                    context: context,
                    fontColor: sectionTitleTextColor(context: context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).applyShimmer(context: context, enable: viewModel.applyShimmer);
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Bonus milestones section
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _BonusMilestonesSection extends StatelessWidget {
  const _BonusMilestonesSection({required this.viewModel});
  final ReferralBenefitsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final List<ReferralMilestoneModel> milestones =
        viewModel.referralProgress?.milestones ?? <ReferralMilestoneModel>[];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            titleTextColor(context: context).withValues(alpha: 0.04),
            sectionTitleTextColor(context: context).withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainBorderColor(context: context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ðŸŽ– BONUS MILESTONES header
          Row(
            children: <Widget>[
              const Text("🎖", style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                LocaleKeys.referralBenefits_bonusMilestones.tr().toUpperCase(),
                style: captionTwoNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ).copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (milestones.isNotEmpty)
            ...milestones.asMap().entries.map(
              (MapEntry<int, ReferralMilestoneModel> entry) {
                final bool isLast = entry.key == milestones.length - 1;
                final ReferralMilestoneModel m = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        isLast ? Icons.emoji_events_rounded : Icons.star_rounded,
                        size: 16,
                        color: m.reached == true
                            ? enabledMainButtonColor(context: context)
                            : secondaryTextColor(context: context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${m.target} referrals",
                          style: captionOneNormalTextStyle(
                            context: context,
                            fontColor: m.reached == true
                                ? mainDarkTextColor(context: context)
                                : secondaryTextColor(context: context),
                          ),
                        ),
                      ),
                      Text(
                        "+€${m.bonus?.toStringAsFixed(0) ?? "0"}",
                        style: captionOneBoldTextStyle(
                          context: context,
                          fontColor: sectionTitleTextColor(context: context),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          else ...<Widget>[
            _MilestoneFallbackRow(
              context: context,
              icon: Icons.star_rounded,
              label: "5 referrals",
              bonus: "+€15",
            ),
            const SizedBox(height: 8),
            _MilestoneFallbackRow(
              context: context,
              icon: Icons.emoji_events_rounded,
              label: "10 referrals",
              bonus: "+€20",
            ),
          ],
        ],
      ),
    ).applyShimmer(context: context, enable: viewModel.applyShimmer);
  }
}

class _MilestoneFallbackRow extends StatelessWidget {
  const _MilestoneFallbackRow({
    required this.context,
    required this.icon,
    required this.label,
    required this.bonus,
  });
  // ignore: diagnostic_describe_all_properties
  final BuildContext context;
  final IconData icon;
  final String label;
  final String bonus;

  @override
  Widget build(BuildContext outerContext) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: secondaryTextColor(context: context)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: captionOneNormalTextStyle(
              context: context,
              fontColor: secondaryTextColor(context: context),
            ),
          ),
        ),
        Text(
          bonus,
          style: captionOneBoldTextStyle(
            context: context,
            fontColor: sectionTitleTextColor(context: context),
          ),
        ),
      ],
    );
  }
}

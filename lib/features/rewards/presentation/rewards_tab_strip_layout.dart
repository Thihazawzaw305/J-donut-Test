import '../../../core/constants/app_dimens.dart';

/// Top of the tab strip so its vertical center sits on [whitePanelHeight].
double rewardsTabStripTop(double whitePanelHeight) {
  return whitePanelHeight - AppDimens.rewardsSegmentedBarHeight / 2;
}

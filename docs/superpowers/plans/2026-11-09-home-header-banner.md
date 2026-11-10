# Home header + banner carousel Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Match home mock — peach header, compact profile row, flush notification pill, left tier chip, tight carousel spacing, infinite manual banners.

**Architecture:** Presentation-only token + widget edits; `PageView` modulo loop; no catalog/domain changes.

**Tech Stack:** Flutter, Riverpod (unchanged), widget tests via `pumpApp`.

## Global Constraints

- No new pub dependencies.
- Strings via l10n only; colors/dimens from `AppColors` / `AppDimens`.
- TDD: failing widget test before each widget change.
- `flutter analyze` clean after merge.

---

### Task 1: Design tokens

**Files:** `app_colors.dart`, `app_dimens.dart`, `app_text_styles.dart`

- [ ] Set `homeHeader` to `heroPeach`.
- [ ] Add notification + tier pill dimens per spec.
- [ ] Add `homeMemberName`, `homeTierPill` text styles.

### Task 2: `HomeNotificationButton` (TDD)

**Test:** `test/features/home/presentation/widgets/home_notification_button_test.dart`

- [ ] Red: border width 3, height 36.
- [ ] Green: implement stroke + sizing.

### Task 3: `HomeHeaderPanel` (TDD)

**Test:** `test/features/home/presentation/widgets/home_header_panel_test.dart`

- [ ] Red: name 18px; tier chip width &lt; 80% screen; left align.
- [ ] Green: padding, styles, layout.

### Task 4: `HomeBannerCarousel` (TDD)

**Test:** `test/features/home/presentation/widgets/home_banner_carousel_test.dart`

- [ ] Red: no autoplay after 5s; drag changes banner.
- [ ] Green: remove timer; infinite `PageView`.

### Task 5: Skeleton + verify

- [ ] `home_loading_skeleton.dart` uses peach (via token).
- [ ] `flutter test` + `flutter analyze`.

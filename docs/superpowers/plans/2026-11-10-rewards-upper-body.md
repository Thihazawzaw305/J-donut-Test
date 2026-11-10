# Rewards upper body (phase 1) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `RewardsPage` placeholder with tier ladder, clipped donut ring, Rewards pill, segmented tabs, and entrance motion — wired to shared `CatalogMember` seed data.

**Architecture:** Extend catalog member row (Drift v2 + JSON). Pure Dart under `features/rewards/domain/`. Thin `RewardsPage` composes small widgets; ring via `CustomPainter`; animations driven by controllers + `AppMotion` tokens.

**Tech Stack:** Flutter, Riverpod, Drift, go_router (unchanged), gen-l10n, flutter_test.

## Global Constraints

- Spec: `docs/superpowers/specs/2026-11-10-rewards-upper-body-design.md`
- Clean Architecture: domain has no Flutter imports; widgets use `context.l10n`, `AppColors`, `AppDimens`, `AppMotion.of`
- Single member source: `catalogMemberProvider` (same as Home)
- TDD: failing test → run fail → minimal code → pass → analyze
- Reduce Motion: skip slides/stagger; jump ring + points to final values
- Phase 1: no challenge lists, no Earn button logic
- Do not commit client PDF screenshots; badge PNGs from bundled seed assets only

---

## File map

| File | Responsibility |
|------|----------------|
| `lib/features/rewards/domain/rewards_tier.dart` | Tier enum + `tierFromCode`, `isTierReached` |
| `lib/features/rewards/domain/rewards_ring_progress.dart` | `rewardsRingSweepFraction` |
| `lib/features/catalog/domain/entities/catalog_member.dart` | Add `rewardsPillCount`, `tierLadderFillBp` |
| `lib/features/catalog/data/datasources/local/catalog_tables.dart` | New columns |
| `lib/features/catalog/data/datasources/local/app_database.dart` | `schemaVersion` 2 + `onUpgrade` |
| `assets/seed/catalog_v1.json` | Silver member + new fields |
| `lib/features/catalog/data/seed/catalog_seed_bundle.dart` | Parse new JSON fields |
| `lib/features/catalog/data/mappers/catalog_row_mappers.dart` | Map new columns |
| `lib/features/catalog/data/seed/catalog_seeder.dart` | Insert/update companions |
| `lib/core/constants/app_motion.dart` | Rewards motion constants |
| `lib/core/constants/app_dimens.dart` | Rewards layout constants |
| `lib/l10n/app_en.arb` | Rewards + `memberSubtitleSilver` strings |
| `lib/features/catalog/presentation/catalog_strings.dart` | `memberSubtitleSilver` in switch |
| `lib/features/rewards/presentation/pages/rewards_page.dart` | AsyncValue + entrance |
| `lib/features/rewards/presentation/widgets/*.dart` | UI pieces per spec |
| `assets/images/seed/rewards/tier_*.png` | Badge assets |
| `test/features/rewards/domain/*_test.dart` | Domain unit tests |
| `test/features/catalog/data/seed/catalog_seed_bundle_test.dart` | Extend expectations |
| `test/features/catalog/data/datasources/app_database_migration_test.dart` | v2 columns (new) |
| `test/features/rewards/presentation/widgets/*_test.dart` | Widget tests |

---

### Task 1: Domain — tier + ring fraction (TDD)

**Files:**
- Create: `test/features/rewards/domain/rewards_tier_test.dart`
- Create: `test/features/rewards/domain/rewards_ring_progress_test.dart`
- Create: `lib/features/rewards/domain/rewards_tier.dart`
- Create: `lib/features/rewards/domain/rewards_ring_progress.dart`

**Interfaces:**
- Produces: `RewardsTier`, `tierFromCode(String code)`, `bool isTierReached(String currentCode, RewardsTier step)`, `double rewardsRingSweepFraction(CatalogMember member)`

- [ ] **Step 1: Write failing tier tests**

`test/features/rewards/domain/rewards_tier_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/rewards/domain/rewards_tier.dart';

void main() {
  test('tierFromCode maps silver', () {
    expect(tierFromCode('silver'), RewardsTier.silver);
  });

  test('silver member has reached silver not gold', () {
    expect(isTierReached('silver', RewardsTier.silver), isTrue);
    expect(isTierReached('silver', RewardsTier.gold), isFalse);
  });
}
```

- [ ] **Step 2: Run test — expect FAIL** (file missing)

Run: `flutter test test/features/rewards/domain/rewards_tier_test.dart`

- [ ] **Step 3: Implement `rewards_tier.dart`**

```dart
enum RewardsTier { silver, gold, platinum }

RewardsTier tierFromCode(String code) => switch (code) {
      'silver' => RewardsTier.silver,
      'gold' => RewardsTier.gold,
      'platinum' => RewardsTier.platinum,
      _ => RewardsTier.silver,
    };

bool isTierReached(String currentCode, RewardsTier step) {
  final current = tierFromCode(currentCode);
  return current.index >= step.index;
}
```

- [ ] **Step 4: Write failing ring fraction tests**

`test/features/rewards/domain/rewards_ring_progress_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/rewards/domain/rewards_ring_progress.dart';

CatalogMember _member({int fillBp = 3500}) => const CatalogMember(
      displayName: 'T',
      subtitleKey: 'memberSubtitleSilver',
      avatarAsset: 'a',
      tierProgressKey: 'memberTierProgressGold',
      tierProgressKyats: 0,
      notificationCount: 0,
      tierCode: 'silver',
      pointsBalance: 680000,
      pointsToNextTier: 500,
      rewardsPillCount: 3,
      tierLadderFillBp: 3500,
    ).copyWith(tierLadderFillBp: fillBp);

void main() {
  test('sweep fraction is fill basis points over 10000', () {
    expect(rewardsRingSweepFraction(_member(fillBp: 3500)), 0.35);
  });

  test('sweep clamps above 10000 bp', () {
    expect(rewardsRingSweepFraction(_member(fillBp: 20000)), 1.0);
  });
}
```

Note: add `copyWith` on `CatalogMember` in Task 2 if missing — or inline full constructor in test until Task 2 lands.

- [ ] **Step 5: Stub `rewards_ring_progress.dart` returning wrong value, run ring test FAIL**

- [ ] **Step 6: Implement**

```dart
import '../../catalog/domain/entities/catalog_member.dart';

double rewardsRingSweepFraction(CatalogMember member) {
  final raw = member.tierLadderFillBp / 10000.0;
  if (raw <= 0) return 0;
  if (raw >= 1) return 1;
  return raw;
}
```

- [ ] **Step 7: Run both domain tests PASS**

Run: `flutter test test/features/rewards/domain/`

---

### Task 2: Catalog member + seed JSON (TDD)

**Files:**
- Modify: `lib/features/catalog/domain/entities/catalog_member.dart`
- Modify: `assets/seed/catalog_v1.json`
- Modify: `lib/features/catalog/data/seed/catalog_seed_bundle.dart`
- Modify: `test/features/catalog/data/seed/catalog_seed_bundle_test.dart`
- Modify: `lib/l10n/app_en.arb` (only `memberSubtitleSilver` here)
- Modify: `lib/features/catalog/presentation/catalog_strings.dart`

**Interfaces:**
- Consumes: domain tests may need updated `CatalogMember` constructor
- Produces: `CatalogMember` with `rewardsPillCount`, `tierLadderFillBp`; seed values per spec

- [ ] **Step 1: Extend failing bundle test**

Add to `catalog_seed_bundle_test.dart`:

```dart
    expect(bundle.member.tierCode, 'silver');
    expect(bundle.member.pointsBalance, 680000);
    expect(bundle.member.pointsToNextTier, 500);
    expect(bundle.member.rewardsPillCount, 3);
    expect(bundle.member.tierLadderFillBp, 3500);
```

- [ ] **Step 2: Run test — FAIL**

- [ ] **Step 3: Update `catalog_v1.json` member block** (per spec)

- [ ] **Step 4: Add fields to `CatalogMember` + optional `copyWith`**

```dart
  final int rewardsPillCount;
  final int tierLadderFillBp;
```

- [ ] **Step 5: Update `_parseMember`**

```dart
  rewardsPillCount: json['rewardsPillCount'] as int? ?? 0,
  tierLadderFillBp: json['tierLadderFillBp'] as int? ?? 0,
```

- [ ] **Step 6: ARB + catalog_strings**

`memberSubtitleSilver`: `"Silver member"`  
Add to `catalogString` switch.

- [ ] **Step 7: Run bundle test + domain tests PASS**

Run: `flutter test test/features/catalog/data/seed/catalog_seed_bundle_test.dart test/features/rewards/domain/`

- [ ] **Step 8: `flutter gen-l10n` or `flutter pub get`** if ARB changed

---

### Task 3: Drift schema v2 + migration (TDD)

**Files:**
- Modify: `lib/features/catalog/data/datasources/local/catalog_tables.dart`
- Modify: `lib/features/catalog/data/datasources/local/app_database.dart`
- Modify: `lib/features/catalog/data/mappers/catalog_row_mappers.dart`
- Modify: `lib/features/catalog/data/seed/catalog_seeder.dart`
- Create: `test/features/catalog/data/datasources/app_database_migration_test.dart`

**Interfaces:**
- Produces: DB rows with `rewards_pill_count`, `tier_ladder_fill_bp`

- [ ] **Step 1: Write migration test**

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/data/datasources/local/app_database.dart';

void main() {
  test('schema v2 member row has rewards columns', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.into(db.memberRows).insert(
          MemberRowsCompanion.insert(
            id: 'default',
            displayName: 'T',
            subtitleKey: 'memberSubtitleSilver',
            avatarAsset: 'a',
            tierProgressKey: 'memberTierProgressGold',
            tierProgressKyats: 0,
            notificationCount: 0,
            tierCode: 'silver',
            pointsBalance: 680000,
            pointsToNextTier: 500,
            rewardsPillCount: 3,
            tierLadderFillBp: 3500,
          ),
        );

    final row = await (db.select(db.memberRows)..limit(1)).getSingle();
    expect(row.rewardsPillCount, 3);
    expect(row.tierLadderFillBp, 3500);
  });
}
```

- [ ] **Step 2: Run FAIL** (columns missing)

- [ ] **Step 3: Add columns to `MemberRows`**

```dart
  IntColumn get rewardsPillCount => integer().withDefault(const Constant(0))();
  IntColumn get tierLadderFillBp => integer().withDefault(const Constant(0))();
```

- [ ] **Step 4: Bump `schemaVersion` to 2 + migration**

```dart
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(
              memberRows,
              memberRows.rewardsPillCount,
            );
            await migrator.addColumn(
              memberRows,
              memberRows.tierLadderFillBp,
            );
          }
        },
      );
```

- [ ] **Step 5: Regenerate Drift**

Run: `dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 6: Update mapper + seeder companions** for new fields

- [ ] **Step 7: Run migration test + bundle test PASS**

---

### Task 4: Motion, dimens, Rewards l10n

**Files:**
- Modify: `lib/core/constants/app_motion.dart`
- Modify: `lib/core/constants/app_dimens.dart`
- Modify: `lib/l10n/app_en.arb`

**Interfaces:**
- Produces: constants used by widgets in Task 5–6

- [ ] **Step 1: Add to `app_motion.dart`**

```dart
  static const rewardsEntrance = Duration(milliseconds: 500);
  static const rewardsEntranceOffset = 24.0;
  static const rewardsTierStagger = Duration(milliseconds: 80);
  static const rewardsRingSweep = Duration(milliseconds: 1400);
  static const rewardsPointsCountUp = rewardsRingSweep;
  static const rewardsPillPopDelay = Duration(milliseconds: 200);
  static const rewardsPillPop = Duration(milliseconds: 320);
  static const rewardsTabThumb = Duration(milliseconds: 280);
```

- [ ] **Step 2: Add to `app_dimens.dart` (names indicative)**

```dart
  static const rewardsDonutDiameter = 280.0;
  static const rewardsDonutStroke = 36.0;
  static const rewardsDonutClipOverflowFraction = 0.5;
  static const rewardsTierBadgeSize = 48.0;
  static const rewardsTierConnectorWidth = 3.0;
  static const rewardsSegmentedBarHeight = 44.0;
```

- [ ] **Step 3: Add ARB keys from spec** (`rewardsScreenTitle`, tier titles/subtitles, tabs, errors)

- [ ] **Step 4: `flutter analyze` on constants + l10n**

---

### Task 5: Badge assets + donut painter (TDD)

**Files:**
- Create: `assets/images/seed/rewards/tier_silver.png` (copy from chat assets)
- Create: `assets/images/seed/rewards/tier_gold.png`
- Create: `assets/images/seed/rewards/tier_platinum.png`
- Modify: `pubspec.yaml` if folder not covered by `assets/images/seed/`
- Create: `lib/features/rewards/presentation/widgets/rewards_donut_ring_painter.dart`
- Create: `test/features/rewards/presentation/widgets/rewards_donut_ring_painter_test.dart`

**Interfaces:**
- Produces: `RewardsDonutRingPainter({required double progress})` drawing track + arc

- [ ] **Step 1: Copy PNGs into `assets/images/seed/rewards/`**

- [ ] **Step 2: Write painter test** (pump `CustomPaint` with `progress: 0` vs `0.5`, `find.byType(CustomPaint)` or golden optional; minimum: painter `shouldRepaint` when progress changes)

```dart
test('RewardsDonutRingPainter repaints when progress changes', () {
  final a = RewardsDonutRingPainter(progress: 0);
  final b = RewardsDonutRingPainter(progress: 0.5);
  expect(a.shouldRepaint(b), isTrue);
});
```

- [ ] **Step 3: Implement painter** — grey full circle stroke, pink arc `sweepAngle = 2*pi*progress` from top; sprinkle dashes on arc only (deterministic positions)

- [ ] **Step 4: Run painter test PASS**

---

### Task 6: Widgets — ladder, hero, pill, ring shell, tabs (TDD)

**Files:**
- Create: `lib/features/rewards/presentation/widgets/rewards_tier_step.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_tier_ladder.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_pill_button.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_donut_ring.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_hero_row.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_segmented_tabs.dart`
- Create: `test/features/rewards/presentation/widgets/rewards_tier_ladder_test.dart`

**Interfaces:**
- Consumes: `CatalogMember`, `AppLocalizations`, animation values passed from parent (opacity, offset, connectorFill, ringProgress, displayedPoints, pillScale)

- [ ] **Step 1: Widget test — gold subtitle contains 500**

Pump `RewardsTierLadder` with test member + `MediaQuery.disableAnimations: true`.

```dart
expect(find.textContaining('500'), findsOneWidget);
```

- [ ] **Step 2: Implement ladder** — three `RewardsTierStep`; `ColorFiltered` matrix desaturate when `!isTierReached`; connector between silver/gold uses `FractionallySizedBox` height = animated fill

- [ ] **Step 3: `RewardsDonutRing`** — `ClipRect` + `Align(alignment: Alignment.centerRight)` + `Transform.translate` to push ~50% off screen; center column with l10n label + formatted points

- [ ] **Step 4: `RewardsSegmentedTabs`** — `Stack` + `AnimatedAlign` thumb; `onSelectionChanged` updates local index

- [ ] **Step 5: Run widget test PASS**

---

### Task 7: `RewardsPage` integration + loading/error (TDD)

**Files:**
- Modify: `lib/features/rewards/presentation/pages/rewards_page.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_loading_skeleton.dart`
- Create: `lib/features/rewards/presentation/widgets/rewards_error_body.dart`
- Create: `test/features/rewards/presentation/pages/rewards_page_test.dart`

**Interfaces:**
- Consumes: `catalogMemberProvider` override in tests

- [ ] **Step 1: Widget test with ProviderScope override**

```dart
final member = CatalogMember(/* silver seed values */);
await tester.pumpApp(
  ProviderScope(
    overrides: [
      catalogMemberProvider.overrideWith((ref) => Stream.value(member)),
    ],
    child: const RewardsPage(),
  ),
);
await tester.pumpAndSettle();
expect(find.textContaining('J'), findsWidgets); // rewardsScreenTitle
```

- [ ] **Step 2: Implement `RewardsPage`**

`ConsumerStatefulWidget`:  
- loading → skeleton  
- error → retry invalidates provider  
- data → `Column` hero, `Expanded` body row, tabs, small bottom spacer  
- `initState`: single `AnimationController` (duration `rewardsRingSweep`) drives ring + `IntTween(0, member.pointsBalance)`  
- secondary controllers or intervals for left/right `SlideTransition` + `FadeTransition`, tier stagger via `Interval` per step, pill `ScaleTransition` with delay  

Wire `MediaQuery.disableAnimationsOf(context)` → set controller to 1.0 on first frame.

- [ ] **Step 3: Reduce-motion widget test**

```dart
await tester.pumpApp(
  MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: ProviderScope(/* same override */, child: const RewardsPage()),
  ),
);
await tester.pump();
expect(find.textContaining('680'), findsOneWidget);
```

- [ ] **Step 4: Run rewards_page tests PASS**

---

### Task 8: Verification

- [ ] **Run full test suite**

Run: `flutter test`

- [ ] **Run analyzer**

Run: `flutter analyze`

Expected: no issues

- [ ] **Manual smoke**

Run app → Reward tab → confirm entrance, ring sweep, Home header shows Silver + 500 to Gold

---

## Plan self-review

| Spec requirement | Task |
|------------------|------|
| Member seed A | Task 2 |
| Drift v2 fields | Task 3 |
| Domain ring/tier | Task 1 |
| CustomPainter ring | Task 5 |
| Tier ladder + stagger | Task 6–7 |
| Clipped donut | Task 6 |
| Rewards pill pop | Task 7 |
| Segmented tabs thumb | Task 6 |
| AsyncValue states | Task 7 |
| Reduce motion | Task 7 |
| ARB / no hardcoded strings | Task 2, 4 |
| Assets | Task 5 |

No TBD placeholders in tasks. Type names consistent: `rewardsRingSweepFraction`, `CatalogMember.rewardsPillCount`.

---

## Execution handoff

Plan saved to `docs/superpowers/plans/2026-11-10-rewards-upper-body.md`.

**1. Subagent-Driven (recommended)** — fresh subagent per task, review between tasks  

**2. Inline Execution** — implement in this session task-by-task with checkpoints  

Reply **1** or **2** (or “start inline”) to begin implementation.

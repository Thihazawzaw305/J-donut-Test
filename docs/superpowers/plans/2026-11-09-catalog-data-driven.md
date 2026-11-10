# Catalog Data-Driven Presentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire catalog Home/Product UI strictly to seed/Drift entities (lists, images, prices, tier keys) with l10n resolution helpers—fixing the tier pill bypass and locking behavior with TDD.

**Architecture:** Keep Task 2 stack: JSON → Drift → `CatalogRepository` → Riverpod. Add `catalogMemberTierProgress` beside `catalogString` in catalog presentation. `HomeHeaderPanel` consumes member fields only. Tests prove changing entity numbers changes UI text.

**Tech Stack:** Flutter 3.x, Riverpod, gen-l10n (`AppLocalizationsEn`), flutter_test, existing `pumpApp` / `catalogDatabaseOverride`.

## Global Constraints

- No hardcoded catalog product/shop/section **titles** in `lib/features/{home,product,catalog}/presentation/` (except `catalog_strings.dart` key map).
- Catalog structure, prices, images, IDs from `assets/seed/catalog_v1.json` / Drift only.
- User-visible chrome stays `context.l10n` / ARB.
- TDD: failing test before production change; watch test fail for expected reason.
- Spec: `docs/superpowers/specs/2026-11-09-catalog-data-driven-design.md`.

## Files touched (summary)

| Action | Path |
|--------|------|
| Create | `test/features/catalog/presentation/catalog_strings_test.dart` |
| Modify | `lib/features/catalog/presentation/catalog_strings.dart` |
| Modify | `lib/features/home/presentation/widgets/home_header_panel.dart` |
| Modify | `test/features/home/presentation/widgets/home_header_panel_test.dart` |
| Modify | `test/features/product/presentation/product_detail_page_test.dart` |

---

### Task 1: `catalogMemberTierProgress` (unit)

**Files:**
- Create: `test/features/catalog/presentation/catalog_strings_test.dart`
- Modify: `lib/features/catalog/presentation/catalog_strings.dart`

**Interfaces:**
- Consumes: `AppLocalizations` (use `AppLocalizationsEn()` in tests), `CatalogMember` from `lib/features/catalog/domain/entities/catalog_member.dart`
- Produces: `String catalogMemberTierProgress(AppLocalizations l10n, CatalogMember member)`

- [ ] **Step 1: Write the failing test**

Create `test/features/catalog/presentation/catalog_strings_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/catalog/presentation/catalog_strings.dart';
import 'package:j_donuts_app/l10n/app_localizations_en.dart';

void main() {
  test('catalogMemberTierProgress formats kyats from member', () {
    const member = CatalogMember(
      displayName: 'Test',
      subtitleKey: 'memberSubtitleEwallet',
      avatarAsset: 'assets/images/seed/member_avatar.png',
      tierProgressKey: 'memberTierProgressSilver',
      tierProgressKyats: 999,
      notificationCount: 0,
      tierCode: 'bronze',
      pointsBalance: 0,
      pointsToNextTier: 0,
    );
    final l10n = AppLocalizationsEn();
    final text = catalogMemberTierProgress(l10n, member);
    expect(text, contains('999'));
    expect(text, contains('kyats left'));
  });

  test('catalogMemberTierProgress returns empty for unknown tier key', () {
    const member = CatalogMember(
      displayName: 'Test',
      subtitleKey: 'memberSubtitleEwallet',
      avatarAsset: 'x',
      tierProgressKey: 'unknownTierKey',
      tierProgressKyats: 100,
      notificationCount: 0,
      tierCode: 'bronze',
      pointsBalance: 0,
      pointsToNextTier: 0,
    );
  final l10n = AppLocalizationsEn();
    expect(catalogMemberTierProgress(l10n, member), isEmpty);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/catalog/presentation/catalog_strings_test.dart`

Expected: FAIL — `catalogMemberTierProgress` is not defined.

- [ ] **Step 3: Write minimal implementation**

Add to `lib/features/catalog/presentation/catalog_strings.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../domain/entities/catalog_member.dart';
import '../../../l10n/app_localizations.dart';

String catalogMemberTierProgress(AppLocalizations l10n, CatalogMember member) {
  final kyats = NumberFormat('#,###').format(member.tierProgressKyats);
  return switch (member.tierProgressKey) {
    'memberTierProgressSilver' => l10n.memberTierProgressSilver(kyats),
    _ => () {
        assert(() {
          debugPrint('Unknown tierProgressKey: ${member.tierProgressKey}');
          return true;
        }());
        return '';
      }(),
  };
}
```

(Keep existing `catalogString` at bottom of file unchanged.)

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/catalog/presentation/catalog_strings_test.dart`

Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add test/features/catalog/presentation/catalog_strings_test.dart lib/features/catalog/presentation/catalog_strings.dart
git commit -m "feat: resolve member tier progress copy from seed keys"
```

---

### Task 2: Home header uses tier resolver (widget)

**Files:**
- Modify: `lib/features/home/presentation/widgets/home_header_panel.dart`
- Modify: `test/features/home/presentation/widgets/home_header_panel_test.dart`

**Interfaces:**
- Consumes: `catalogMemberTierProgress(l10n, member)` from Task 1
- Produces: Tier pill `Text` built from resolver output (not direct `memberTierProgressSilver` call)

- [ ] **Step 1: Write the failing test**

In `home_header_panel_test.dart`, change fixture member and assertion:

```dart
const _member = CatalogMember(
  displayName: 'Hania',
  subtitleKey: 'memberSubtitleEwallet',
  avatarAsset: 'assets/images/seed/member_avatar.png',
  tierProgressKey: 'memberTierProgressSilver',
  tierProgressKyats: 50001, // matches seed number, not implicit 100
  notificationCount: 2,
  tierCode: 'bronze',
  pointsBalance: 0,
  pointsToNextTier: 1290,
);
```

After `pumpAndSettle`, replace generic `kyats left` expectation with:

```dart
expect(find.textContaining('50,001'), findsOneWidget);
```

If test passes **before** header fix while still using hardcoded l10n with old `100` fixture, the test already used 100 — updating to `50001` should fail until header reads `member.tierProgressKyats` via resolver.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/home/presentation/widgets/home_header_panel_test.dart`

Expected: FAIL — finds `100` or old formatted value, not `50,001` (if header still wrong), OR fails if header hardcodes formatter but you already changed fixture from 100 to 50001.

- [ ] **Step 3: Wire header**

In `home_header_panel.dart`, remove:

```dart
final kyats = NumberFormat('#,###').format(member.tierProgressKyats);
final tierText = context.l10n.memberTierProgressSilver(kyats);
```

Replace with:

```dart
final tierText = catalogMemberTierProgress(context.l10n, member);
```

Remove unused `intl` import if no longer needed in this file.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/home/presentation/widgets/home_header_panel_test.dart`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/presentation/widgets/home_header_panel.dart test/features/home/presentation/widgets/home_header_panel_test.dart
git commit -m "fix: home tier pill reads tierProgressKey and kyats from member"
```

---

### Task 3: Product detail price from entity (widget)

**Files:**
- Modify: `test/features/product/presentation/product_detail_page_test.dart`

**Interfaces:**
- Consumes: `productByIdProvider` family override, `CatalogProduct`, `formatMmkPrice`
- Produces: No production changes unless test exposes a bug (detail already uses `product.priceMmk`)

- [ ] **Step 1: Write the failing test**

Add new test at end of `product_detail_page_test.dart`:

```dart
import 'package:j_donuts_app/core/di/catalog_providers.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_product.dart';

testWidgets('unit price reflects product entity priceMmk', (tester) async {
  const overrideProduct = CatalogProduct(
    id: 'p_coconut',
    code: 'JD022123',
    nameKey: 'productCoconutDonut',
    priceMmk: 9999,
    isNew: false,
    discountPercent: null,
    imageAsset: 'assets/images/seed/p_coconut.png',
    imageUrl: null,
    descriptionKey: 'productCoconutDescription',
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        productByIdProvider('p_coconut').overrideWith(
          (ref) async => overrideProduct,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ProductDetailPage(productId: 'p_coconut'),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));

  expect(find.text('9,999 Ks'), findsWidgets);
});
```

- [ ] **Step 2: Run test to verify it fails or passes**

Run: `flutter test test/features/product/presentation/product_detail_page_test.dart`

Expected: If detail already binds `product.priceMmk`, PASS immediately — test documents contract. If FAIL, fix `ProductDetailPage` to use entity price (should not be needed).

- [ ] **Step 3: Minimal fix (only if Step 2 failed)**

Align detail page with `formatMmkPrice(product.priceMmk)` anywhere price is shown.

- [ ] **Step 4: Re-run product + catalog + header tests**

Run:

```bash
flutter test test/features/product/presentation/product_detail_page_test.dart test/features/catalog/presentation/catalog_strings_test.dart test/features/home/presentation/widgets/home_header_panel_test.dart
```

Expected: all PASS.

- [ ] **Step 5: Commit**

```bash
git add test/features/product/presentation/product_detail_page_test.dart
git commit -m "test: assert product detail price comes from entity priceMmk"
```

---

### Task 4: Full verification

**Files:** none (commands only)

- [ ] **Step 1: Analyze**

Run: `flutter analyze`

Expected: No issues.

- [ ] **Step 2: Full unit/widget suite**

Run: `flutter test`

Expected: PASS.

- [ ] **Step 3: Integration (optional on device)**

Run: `flutter test integration_test/register_to_product_test.dart`

Expected: `Coconut Donut` and `3,200 Ks` still found.

- [ ] **Step 4: Commit spec/plan if not yet committed**

```bash
git add docs/superpowers/specs/2026-11-09-catalog-data-driven-design.md docs/superpowers/plans/2026-11-09-catalog-data-driven.md
git commit -m "docs: catalog data-driven presentation spec and plan"
```

---

## Plan self-review (vs spec)

| Spec requirement | Task |
|------------------|------|
| Tier uses `tierProgressKey` + kyats | 1, 2 |
| Widget audit / no bypass | 2 (header) |
| Price from data | 3 |
| TDD red-green | Each task |
| Integration regression | Task 4 |
| Optional literal guard test | Omitted (YAGNI; spec optional) |

No placeholders. All paths and signatures defined in Task 1 before Task 2 uses them.

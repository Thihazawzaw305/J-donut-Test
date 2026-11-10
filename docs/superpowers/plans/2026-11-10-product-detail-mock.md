# Product Detail Mock Fidelity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reshape `ProductDetailPage` to match the approved item-details mock: hero card with SKU + New badge, overlapping quantity stepper, two-column “What’s this?” block, while keeping favorite, `Ks` pricing, and toast-only cart.

**Architecture:** Presentation-only split: `ProductDetailHeroCard` and `ProductDetailDescriptionPanel` take pre-resolved strings and callbacks; page keeps `productByIdProvider` and `_quantity`. Reuse `ProductQuantityStepper`, `ProductDetailFooter`, `CatalogImage`. New `AppDimens` product-detail tokens.

**Tech Stack:** Flutter, Riverpod, go_router, gen-l10n, flutter_test, integration_test.

## Global Constraints

- Spec: `docs/superpowers/specs/2026-11-10-product-detail-mock-design.md`
- Clean Architecture: no hardcoded user strings/colors; ARB + `AppColors` / `AppDimens` / `AppTextStyles`
- Prices: `formatMmkPrice` → `X,XXX Ks` on card and footer
- Card badges: `code` top-left; `productNewBadge` when `isNew`; never show `discountBadge` on detail
- Header: back + favorite → `comingSoon` toast
- Help icon: decorative (no `onTap`)
- TDD: failing test before each new widget file; verify red then green
- Files ~300 lines max; page thin after refactor

---

## File map

| File | Responsibility |
|------|----------------|
| `lib/core/constants/app_dimens.dart` | `productDetailImageHeight`, `productDetailStepperOverlap`, `productDetailHelpColumnWidth`, `productDetailHelpDividerWidth` |
| `lib/features/product/presentation/widgets/product_detail_hero_card.dart` | White card stack + overlapping stepper |
| `lib/features/product/presentation/widgets/product_detail_description_panel.dart` | Help column + divider + description |
| `lib/features/product/presentation/pages/product_detail_page.dart` | Compose providers, app bar, scroll, footer |
| `test/.../product_detail_hero_card_test.dart` | Hero layout/badge tests |
| `test/.../product_detail_description_panel_test.dart` | Row layout test |
| `test/.../product_detail_page_test.dart` | Existing + favorite tooltip |

---

### Task 1: Product detail dimens tokens

**Files:**
- Modify: `lib/core/constants/app_dimens.dart`

**Interfaces:**
- Produces: `AppDimens.productDetailImageHeight` (220), `productDetailStepperOverlap` (24), `productDetailHelpColumnWidth` (88), `productDetailHelpDividerWidth` (1)

- [ ] **Step 1: Add constants**

Append before closing brace of `AppDimens`:

```dart
  static const productDetailImageHeight = 220.0;
  static const productDetailStepperOverlap = 24.0;
  static const productDetailHelpColumnWidth = 88.0;
  static const productDetailHelpDividerWidth = 1.0;
```

- [ ] **Step 2: Verify analyze**

Run: `flutter analyze lib/core/constants/app_dimens.dart`  
Expected: No issues.

---

### Task 2: `ProductDetailDescriptionPanel` (TDD)

**Files:**
- Create: `test/features/product/presentation/widgets/product_detail_description_panel_test.dart`
- Create: `lib/features/product/presentation/widgets/product_detail_description_panel.dart`

**Interfaces:**
- Produces:

```dart
class ProductDetailDescriptionPanel extends StatelessWidget {
  const ProductDetailDescriptionPanel({
    super.key,
    required this.whatsThisLabel,
    required this.description,
  });

  final String whatsThisLabel;
  final String description;
}
```

- [ ] **Step 1: Write failing test**

Create `product_detail_description_panel_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/product/presentation/widgets/product_detail_description_panel.dart';

void main() {
  testWidgets('whats this and description share horizontal row', (tester) async {
    const panel = ProductDetailDescriptionPanel(
      whatsThisLabel: "What's this?",
      description: 'Soft sweet donuts.',
    );

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: panel)),
    );

    final whatsThis = find.text("What's this?");
    final body = find.text('Soft sweet donuts.');
    expect(whatsThis, findsOneWidget);
    expect(body, findsOneWidget);

    final rowFinder = find.ancestor(
      of: whatsThis,
      matching: find.byType(Row),
    );
    expect(rowFinder, findsWidgets);
    expect(
      find.descendant(of: rowFinder.first, matching: body),
      findsOneWidget,
    );
  });
}
```

- [ ] **Step 2: Run test — expect fail**

Run: `flutter test test/features/product/presentation/widgets/product_detail_description_panel_test.dart`  
Expected: FAIL (file/class not found)

- [ ] **Step 3: Minimal implementation**

Create `product_detail_description_panel.dart`:

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProductDetailDescriptionPanel extends StatelessWidget {
  const ProductDetailDescriptionPanel({
    super.key,
    required this.whatsThisLabel,
    required this.description,
  });

  final String whatsThisLabel;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppDimens.productDetailHelpColumnWidth,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.productHelpGreen,
                child: Icon(
                  Icons.help_outline,
                  size: 14,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Text(whatsThisLabel, style: AppTextStyles.bodyBold),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Container(
          width: AppDimens.productDetailHelpDividerWidth,
          height: 72,
          color: AppColors.tierCapsuleBorder,
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: Text(description, style: AppTextStyles.body),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test — expect pass**

Run: `flutter test test/features/product/presentation/widgets/product_detail_description_panel_test.dart`  
Expected: All tests passed.

---

### Task 3: `ProductDetailHeroCard` (TDD)

**Files:**
- Create: `test/features/product/presentation/widgets/product_detail_hero_card_test.dart`
- Create: `lib/features/product/presentation/widgets/product_detail_hero_card.dart`

**Interfaces:**
- Consumes: `ProductQuantityStepper`, `CatalogImage`, `AppDimens` product detail tokens, l10n passed as `newBadgeLabel`
- Produces:

```dart
class ProductDetailHeroCard extends StatelessWidget {
  const ProductDetailHeroCard({
    super.key,
    required this.productCode,
    required this.name,
    required this.unitPriceLabel,
    required this.imageAsset,
    this.imageUrl,
    required this.showNewBadge,
    required this.newBadgeLabel,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String productCode;
  final String name;
  final String unitPriceLabel;
  final String imageAsset;
  final String? imageUrl;
  final bool showNewBadge;
  final String newBadgeLabel;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
}
```

- [ ] **Step 1: Write failing tests**

Create `product_detail_hero_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/product/presentation/widgets/product_detail_hero_card.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );

void main() {
  testWidgets('shows product code', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductDetailHeroCard(
          productCode: 'JD022123',
          name: 'Coconut Donut',
          unitPriceLabel: '3,200 Ks',
          imageAsset: 'assets/images/seed/p_coconut.png',
          imageUrl: null,
          showNewBadge: false,
          newBadgeLabel: 'New',
          quantity: 1,
          onDecrease: () {},
          onIncrease: () {},
        ),
      ),
    );

    expect(find.text('JD022123'), findsOneWidget);
  });

  testWidgets('shows New badge when showNewBadge is true', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductDetailHeroCard(
          productCode: 'JD022123',
          name: 'Coconut Donut',
          unitPriceLabel: '3,200 Ks',
          imageAsset: 'assets/images/seed/p_coconut.png',
          imageUrl: null,
          showNewBadge: true,
          newBadgeLabel: 'New',
          quantity: 1,
          onDecrease: () {},
          onIncrease: () {},
        ),
      ),
    );

    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('hides New badge when showNewBadge is false', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductDetailHeroCard(
          productCode: 'JD022123',
          name: 'Coconut Donut',
          unitPriceLabel: '3,200 Ks',
          imageAsset: 'assets/images/seed/p_coconut.png',
          imageUrl: null,
          showNewBadge: false,
          newBadgeLabel: 'New',
          quantity: 1,
          onDecrease: () {},
          onIncrease: () {},
        ),
      ),
    );

    expect(find.text('New'), findsNothing);
  });

  testWidgets('does not show discount percent badge', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductDetailHeroCard(
          productCode: 'JD022123',
          name: 'Sale Donut',
          unitPriceLabel: '3,200 Ks',
          imageAsset: 'assets/images/seed/p_coconut.png',
          imageUrl: null,
          showNewBadge: false,
          newBadgeLabel: 'New',
          quantity: 1,
          onDecrease: () {},
          onIncrease: () {},
        ),
      ),
    );

    expect(find.textContaining('-%'), findsNothing);
  });

  testWidgets('stepper sits in stack overlapping card', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ProductDetailHeroCard(
          productCode: 'JD022123',
          name: 'Coconut Donut',
          unitPriceLabel: '3,200 Ks',
          imageAsset: 'assets/images/seed/p_coconut.png',
          imageUrl: null,
          showNewBadge: false,
          newBadgeLabel: 'New',
          quantity: 2,
          onDecrease: () {},
          onIncrease: () {},
        ),
      ),
    );

    final stack = find.descendant(
      of: find.byType(ProductDetailHeroCard),
      matching: find.byType(Stack),
    );
    expect(stack, findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests — expect fail**

Run: `flutter test test/features/product/presentation/widgets/product_detail_hero_card_test.dart`  
Expected: FAIL (class not found)

- [ ] **Step 3: Implement hero card**

Create `product_detail_hero_card.dart` with:

- Outer `Stack` `clipBehavior: Clip.none`
- `Material` white, `BorderRadius.circular(AppDimens.homeCardRadius)`
- Inner `Padding` bottom = `AppDimens.productDetailStepperOverlap + AppDimens.spaceLg`
- Top `Row`: `Text(productCode, style: AppTextStyles.caption)`, `Spacer`, optional `_NewBadge(newBadgeLabel)` when `showNewBadge`
- Title `AppTextStyles.headline`, price `AppTextStyles.bodyBold`
- Image area height `AppDimens.productDetailImageHeight`, `CatalogImage` `BoxFit.contain`
- `Positioned(left: 0, right: 0, bottom: -AppDimens.productDetailStepperOverlap)` → `Center(child: ProductQuantityStepper(...))`

Private badge widget (same as home tile):

```dart
class _NewBadge extends StatelessWidget {
  const _NewBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.notificationOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceXs,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect pass**

Run: `flutter test test/features/product/presentation/widgets/product_detail_hero_card_test.dart`  
Expected: All tests passed.

---

### Task 4: Refactor `ProductDetailPage` to compose widgets

**Files:**
- Modify: `lib/features/product/presentation/pages/product_detail_page.dart`

**Interfaces:**
- Consumes: `ProductDetailHeroCard`, `ProductDetailDescriptionPanel`, `ProductDetailFooter`, existing providers

- [ ] **Step 1: Add failing page test (favorite)**

In `product_detail_page_test.dart`, add:

```dart
  testWidgets('favorite control is present', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [catalogDatabaseOverride()],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProductDetailPage(productId: 'p_jbites_chocolate'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byTooltip('Favorite'), findsOneWidget);
  });
```

- [ ] **Step 2: Run new test on current page — expect pass or fail**

Run: `flutter test test/features/product/presentation/product_detail_page_test.dart --name favorite`  
Expected: PASS already (favorite exists); keeps regression while refactoring.

- [ ] **Step 3: Rewrite page body `data` branch**

Replace inline card + description with:

```dart
ProductDetailHeroCard(
  productCode: product.code,
  name: name,
  unitPriceLabel: unitPrice,
  imageAsset: product.imageAsset,
  imageUrl: product.imageUrl,
  showNewBadge: product.isNew,
  newBadgeLabel: context.l10n.productNewBadge,
  quantity: _quantity,
  onDecrease: () { /* existing min-1 logic */ },
  onIncrease: () => setState(() => _quantity += 1),
),
SizedBox(height: AppDimens.productDetailStepperOverlap + AppDimens.spaceLg),
ProductDetailDescriptionPanel(
  whatsThisLabel: context.l10n.productWhatsThis,
  description: description,
),
```

Remove duplicate `ProductQuantityStepper` and old description `Row` from page.

- [ ] **Step 4: Run all product tests**

Run: `flutter test test/features/product/`  
Expected: All tests passed.

---

### Task 5: Full verification

**Files:** (none)

- [ ] **Step 1: Analyze**

Run: `flutter analyze`  
Expected: No issues.

- [ ] **Step 2: Integration regression**

Run: `flutter test integration_test/register_to_product_test.dart`  
Expected: PASS; still finds `3,200 Ks` on coconut detail.

- [ ] **Step 3: Manual smoke (optional)**

Navigate Home → product tile → confirm overlapping stepper, SKU, New on coconut if seeded `isNew`.

---

## Spec coverage (self-review)

| Spec requirement | Task |
|------------------|------|
| SKU + New badges, no discount | Task 3 tests + hero impl |
| Overlapping stepper | Task 3 stack + dimens Task 1 |
| Description row + divider | Task 2 |
| Favorite + Ks + footer toast | Task 4, existing footer |
| Page thin composition | Task 4 |
| TDD order | Tasks 2–4 |
| Integration regression | Task 5 |

No TBD / placeholder steps in this plan.

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-11-10-product-detail-mock.md`.

**1. Subagent-Driven (recommended)** — fresh subagent per task, review between tasks  

**2. Inline Execution** — run tasks in this session with checkpoints  

Which approach?

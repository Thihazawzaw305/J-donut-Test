# Rewards screen — phase 1 upper body (tier ladder, donut ring, tabs)

Date: 2026-11-10  
Reference: Madivizion Task 3 (§5–§6), user mock (J' Donuts Rewards), code-review amendments 2026-11-10.  
Status: **Approved in chat** — implement only after reader sign-off on this file.

## Purpose

Replace the Rewards placeholder with the **top hero region** of screen 10: title + tier ladder, orange Rewards pill, half-off-screen donut points ring, and Eat more / Gift segmented control. Motion matches Task 3 minimums for this slice. **Challenges, Earn, and tab list content** are phase 2 (separate spec).

## Locked decisions

| Topic | Choice |
|-------|--------|
| Member data | **Option A** — one `catalog_v1.json` member row shared by Home and Rewards |
| Architecture | Thin `RewardsPage` + small widgets + **domain pure functions** + `CustomPainter` ring |
| Ring art | Flutter `CustomPainter` (pink frosting arc + sprinkle dashes), not Rive |
| Tier badges | Bundled PNGs under `assets/images/seed/rewards/`; earned = full color, locked = `ColorFiltered` desaturate |
| Rewards pill count | **New field** `rewardsPillCount` (not Home bell `notificationCount`) |
| Tier connector fill | Seed **`tierLadderFillBp`** (0–10000, ≈0.35 for mock partial Silver→Gold line) |
| Ring sweep target | **`rewardsRingSweepFraction(member)`** returns `tierLadderFillBp / 10000` for phase 1 (same signal as ladder line; independent constant later if design needs) |
| Points label | Animate count **0 → `pointsBalance`** (680,000 in seed), formatted with thousands separators |

## Goals (phase 1)

- **Header row:** localized title (`rewardsScreenTitle` ≈ "J' Donuts Rewards"), orange Rewards capsule + white count circle (`rewardsPillCount`).
- **Body row:** `RewardsTierLadder` (~45% width) + `RewardsDonutRing` (right-aligned, **~50% clipped** off trailing edge).
- **Ladder:** Silver / Gold / Platinum steps; **current tier bright badge**, others dim; copy from l10n + `pointsToNextTier` for Gold line.
- **Connector:** vertical segment Silver→Gold animates fill height **0 → tierLadderFillBp** on entrance (after stagger).
- **Donut:** grey track + pink progress arc; center "Total points" + animated integer.
- **Tabs:** segmented "Eat more earn more" / "Gift" with **sliding cyan thumb**; tap switches selection + scale press feedback; **no list body** in phase 1 (placeholder `SizedBox` or empty padded area).
- **Entrance (first paint):**
  - Title + ladder: fade + slide **from left**; tiers **stagger** Silver → Gold → Platinum (`AppMotion.rewardsTierStagger`).
  - Pill + donut: fade + slide **from right**; pill **pop** (scale) shortly after donut starts.
  - Ring sweep **0 → sweep fraction**; points count-up **in sync** with ring (`AppMotion.rewardsRingSweep`).
- **States:** loading skeleton, error with retry, empty member — mirror `HomePage` / `catalogMemberProvider` patterns.
- **Reduce motion:** `AppMotion.of` — no slide; jump to final arc + final points; skip tier stagger delay (show all at once).
- **Bottom nav:** no change in phase 1; existing `HomeBottomNav` already routes Reward tab (pill slide already on `homeNavSelection`).

## Non-goals (phase 1)

- Challenge cards, coffee/donut challenge artwork, Earn button states.
- Tab content lists and `AnimatedSwitcher` between Eat / Gift lists (phase 2).
- Rewards button navigation (visual feedback only).
- Committing client PDF screenshots.
- Mock HTTP server.

## Member seed (`catalog_v1.json`)

```json
{
  "displayName": "Thiha Zaw Zaw",
  "subtitleKey": "memberSubtitleSilver",
  "avatarAsset": "assets/images/seed/member_avatar.png",
  "tierProgressKey": "memberTierProgressGold",
  "tierProgressKyats": 50001,
  "notificationCount": 2,
  "tierCode": "silver",
  "pointsBalance": 680000,
  "pointsToNextTier": 500,
  "rewardsPillCount": 3,
  "tierLadderFillBp": 3500
}
```

- Home tier capsule uses existing `catalogMemberTierProgress` → "500 points left to become Gold member".
- Home subtitle → new ARB `memberSubtitleSilver`: "Silver member" (replace Bronze copy).

## Data layer changes

1. **`MemberRows` (Drift):** add `rewardsPillCount` (int), `tierLadderFillBp` (int, default 0).
2. **`schemaVersion`:** 1 → 2 with `onUpgrade` adding columns with defaults for existing installs.
3. **`CatalogMember` entity** + `_parseMember` + `mapMemberRow` + seeder companions.
4. **Tests:** seed JSON parse includes new fields; in-memory DB migration v2 preserves or defaults columns.

## Domain (`lib/features/rewards/domain/`)

Pure Dart, no Flutter imports.

| Unit | Responsibility |
|------|----------------|
| `rewards_tier.dart` | `RewardsTier { silver, gold, platinum }`; `tierFromCode(String)`; `isTierReached(current, step)` |
| `rewards_ring_progress.dart` | `rewardsRingSweepFraction(CatalogMember m) => m.tierLadderFillBp / 10000` clamped 0–1 |
| `rewards_tier_ladder.dart` | Ladder step models: badge asset path, title key, subtitle resolver from member + l10n keys in presentation |

**Badge brightness:** `isTierReached(member.tierCode, step)` → false → dim filter.

## Presentation structure

```
lib/features/rewards/
  domain/          (above)
  presentation/
    pages/rewards_page.dart           # ConsumerStatefulWidget, AsyncValue branches, starts entrance once
    widgets/
      rewards_hero_row.dart
      rewards_tier_ladder.dart
      rewards_tier_step.dart
      rewards_pill_button.dart          # orange Rewards + pop animation
      rewards_donut_ring.dart           # ClipRect + CustomPaint + center labels
      rewards_donut_ring_painter.dart
      rewards_segmented_tabs.dart     # sliding thumb
      rewards_loading_skeleton.dart
      rewards_error_body.dart
    providers/                        # optional: rewards_tab_index_notifier (local UI only)
```

**`RewardsPage` wiring**

- `ref.watch(catalogMemberProvider)` — same provider as Home.
- Background: `AppColors` screen token (white / home background per mock).
- `RewardsEntranceController` (private to page or small mixin file): owns `AnimationController`(s) for left/right groups, ring, count-up, tier stagger, pill pop; disposes on dispose.

## Visual / layout tokens

Add to `AppDimens` / `AppColors` as needed (no magic numbers in widgets):

- Donut outer diameter, stroke width, clip alignment, right overflow fraction (~0.5).
- Ladder badge size, connector width, inter-step vertical gap.
- Rewards pill height, orange fill (`AppColors` accent family).
- Segmented tab bar height, thumb radius, inactive grey track.

Strings in `app_en.arb`:

- `rewardsScreenTitle`
- `rewardsPillLabel` ("Rewards")
- `rewardsTierSilverTitle`, `rewardsTierGoldTitle`, `rewardsTierPlatinumTitle`
- `rewardsTierSilverSubtitleHere`, `rewardsTierGoldSubtitlePoints` (`{points}`), `rewardsTierPlatinumSubtitleSoon`
- `rewardsTotalPointsLabel`
- `rewardsEatMoreEarnMore`, `rewardsGiftTab`
- `rewardsLoadError`, `rewardsEmptyMember` (or reuse home keys if identical)

## Motion (`AppMotion`)

Add named durations/curves:

- `rewardsEntrance`, `rewardsEntranceOffset`
- `rewardsTierStagger`
- `rewardsRingSweep`, `rewardsPointsCountUp`
- `rewardsPillPopDelay`, `rewardsPillPop`
- `rewardsTabThumb` (segmented indicator)
- Curve: `standardCurve` unless design needs `easeOutCubic` variant

Reduce motion: zero duration / no offset for entrance; ring and number jump to end values.

## Assets

Copy tier badge PNGs into repo (from user-provided art, not PDF):

- `assets/images/seed/rewards/tier_silver.png`
- `assets/images/seed/rewards/tier_gold.png`
- `assets/images/seed/rewards/tier_platinum.png`

Register in `pubspec.yaml` (directory or explicit files).

## Testing (TDD — phase 1)

| Layer | Tests |
|-------|--------|
| Unit | `rewardsRingSweepFraction` clamp; `isTierReached` for silver/current; tier parse |
| Unit | `CatalogSeedBundle.fromJson` new member fields |
| Drift | migration v2 adds columns; seed insert round-trip |
| Widget | Gold step shows 500 pts message; ladder dims platinum |
| Widget | Reduce motion → donut shows final points without animating controller duration |
| Widget | Ring painter: golden or pump with known sweep (optional, if painter extracted) |

Run `flutter test` + `flutter analyze` clean after phase 1.

## Phase roadmap (full Task 3)

| Phase | Deliverable |
|-------|-------------|
| **1 (this spec)** | Upper body + tabs chrome + motions above + member seed alignment |
| **2** | Challenges in seed/Drift; tab lists; `AnimatedSwitcher`; staggered cards |
| **3** | Per-challenge progress art (donut quarters, coffee arc); Earn states; polish |

## Risks / notes

- **Large point count animation:** use `IntTween` over 1–1.5s; avoid rebuilding whole page each frame (listen to animation, localized `ListenableBuilder`).
- **Performance:** single ring `CustomPainter` with `repaint` bound to animation; sprinkle pattern deterministic (no random per frame).
- **Existing users:** migration defaults `rewardsPillCount: 0`, `tierLadderFillBp: 0` until `refreshFromSeed()` or re-seed path updates row from JSON.

## Self-review (2026-11-10)

- [x] No TBD placeholders on phase 1 scope
- [x] Ring sweep vs points display distinguished
- [x] Ladder stagger + connector fill explicit
- [x] AsyncValue states included
- [x] Drift migration called out
- [x] Full Task 3 deferred with phase table (scope check)

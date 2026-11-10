# Material motion (`animations` ^3.0.0)

## Goal

Page navigation uses Material motion (`SharedAxis`, `FadeThrough`). Product detail uses `OpenContainer` from Home plus `SharedAxis` scaled when routed via `/product/:id`.

## Constraints

- `go_router` stays source of truth for paths and auth redirect.
- Durations from `AppMotion.medium`; zero when `MediaQuery.disableAnimationsOf`.
- Clean Architecture: transitions in `core/router/`; Home widget wraps open-detail only.

## Approach (chosen)

| Flow | Motion |
|------|--------|
| Auth steps (phone → otp → name → dob) | `SharedAxis` horizontal |
| Onboarding, welcome, home | `FadeThrough` |
| Settings | `SharedAxis` vertical |
| Product `/product/:id` | `SharedAxis` scaled |
| Home sample link | `OpenContainer` → `ProductDetailPage` |

Alternatives rejected: raw `PageRouteBuilder` only (no Material patterns); `OpenContainer` for every route (breaks deep links).

## Components

- `lib/core/router/app_page_transitions.dart` — `CustomTransitionPage` factory.
- `lib/core/router/app_router.dart` — all routes use `pageBuilder`.
- `lib/features/home/presentation/widgets/sample_product_open_container.dart`.

## Testing

- `pumpJDonutsApp`: after `go(location)`, pump through `AppMotion.medium` so routes are interactive.
- Widget: `OpenContainer` shows `p_coconut` after tap + settle.
- Widget: deep `go` to product path shows detail with transition pumps.
- Existing `auth_navigation_test` must stay green (register → home → sample product).

## Approval

Retroactive spec for implementation already in tree. Review and reply **approved** or request changes before further motion work.

# CLAUDE.md

Project: iOS ride and delivery prototype
Role: Claude acts as a senior iOS engineer, SwiftUI UI designer, and product prototyping partner for a Product Owner.

## Product goal

Build an internal iOS prototype that lets a Product Owner test new app features inside a modern mobility and delivery super-app experience.

The app should feel familiar to users of premium ride-hailing and delivery apps: clean, high-contrast, map-forward, card-based, bottom-sheet driven, fast to scan, and optimized for quick task completion. It must not copy Uber branding, logos, exact screenshots, proprietary names, proprietary assets, or pixel-perfect trade dress. Use generic product language and original styling.

Primary prototype areas:

- Taxi / ride booking flow.
- Food delivery flow.
- Grocery / retail delivery flow.
- Courier / package delivery flow.
- Activity history.
- Account / profile mock area.
- Product Owner prototype tools for adding banners and simple custom screens.

Registration and login are absent by default. If an auth entry point is needed for a flow, mock it with a local demo user and a single "Continue as Demo User" button.

## Current project assumptions

- This is an iOS app project, probably created empty in Xcode.
- Prefer SwiftUI unless an existing project uses UIKit.
- Prefer native Apple frameworks and SF Symbols.
- No real backend is required.
- No real payments, real orders, real taxi booking, real user tracking, or real authentication.
- Mock all data locally.
- Keep the app useful as a prototype, not production infrastructure.

## Non-negotiable guardrails

1. Do not use Uber logos, Uber product names, Uber screenshots, Uber map assets, or copied visual assets.
2. Do not recreate a screen pixel-for-pixel from Uber or any other commercial app.
3. Do create an original app that uses common ride-hailing and delivery UX patterns: search, map, cards, sheets, service tiles, order cards, banner slots, and quick actions.
4. Do not add real sign-up, OAuth, payment SDKs, live location permissions, push notifications, or network APIs unless explicitly requested.
5. Do not introduce third-party dependencies without explaining why they are needed and asking for approval.
6. Keep all prototype data local and easy to edit.
7. Every new user-facing screen should compile, have mock data, and have a SwiftUI preview where practical.
8. Use accessibility labels for tappable controls and meaningful images.

## Skill usage rules

The project includes or expects agent skills from the Swift Agent Skills directory. Before starting any task, inspect the available skills in `.claude/skills` and `~/.claude/skills`, then use only the skills that match the current task. Do not pretend a skill exists if it is not installed.

Use skills according to the task:

| Task type | Prefer these installed skills if available |
| --- | --- |
| SwiftUI screen creation, layout, components | SwiftUI Pro, SwiftUI UI Patterns, SwiftUI Design Principles |
| Refactoring SwiftUI views | SwiftUI View Refactor, SwiftUI Pro |
| Ride, food, activity, account UI flows | SwiftUI UI Patterns, Writing for Interfaces Skill, SwiftUI Design Principles |
| Design-system decisions | SwiftUI Design Principles, Writing for Interfaces Skill |
| Accessibility pass | iOS Accessibility Agent Skill, Swift Accessibility Skill, Apple Accessibility Skills |
| Local model/persistence work | SwiftData Pro, SwiftData Expert |
| Async mock services, loading states, delayed responses | Swift Concurrency Pro, Swift Concurrency Expert |
| Unit tests and UI logic tests | Swift Testing Pro, Swift Testing Agent Skill, Swift Testing Expert |
| Architecture choices | Swift Architecture Skill |
| Simulator launch and visual verification | iOS Simulator Skill, Claude Code /run, Claude Code /verify |
| Performance review | SwiftUI Performance Audit |
| Security review | Swift Security Expert |
| Widgets or Live Activity style concepts | Widgets Skill |
| Figma/screenshot-to-SwiftUI work | Figma to SwiftUI Skill |
| Code audit before major changes | iOS Code Audit |

When multiple skills are relevant, use the most specific one first. Example: for a new ride option bottom sheet, prefer a SwiftUI UI/layout skill before a general architecture skill. For broad tasks, use a small set of skills, not every installed skill.

If the user explicitly asks for a specific skill, use it if installed. If it is missing, say which skill is missing and continue with the closest available skill.

## Claude workflow for every implementation task

1. Inspect the project structure before editing.
2. Identify the app target, scheme, minimum iOS version, and whether the project uses SwiftUI or UIKit.
3. Choose relevant installed skills for the task.
4. Make the smallest coherent implementation that supports the requested prototype behavior.
5. Prefer reusable components over one-off duplicated UI.
6. Build after meaningful changes.
7. If tests exist, run them. If tests do not exist and the task adds logic, add lightweight tests where practical.
8. Run or verify in the simulator when UI changes are significant.
9. Summarize changed files, what was added, and how to test it.

Do not only explain what to do when the user asks to build. Modify the project files.

## Build and verification commands

First detect the correct project and scheme:

```bash
xcodebuild -list
```

Then build using an available iOS Simulator destination. Prefer a current iPhone simulator installed on the machine:

```bash
xcodebuild -scheme <SchemeName> -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Run tests if a test target exists:

```bash
xcodebuild -scheme <SchemeName> -destination 'platform=iOS Simulator,name=iPhone 16' test
```

If `iPhone 16` is unavailable, list destinations and choose an installed iPhone simulator:

```bash
xcodebuild -scheme <SchemeName> -showdestinations
```

When Claude Code bundled skills are available, use `/run` or `/verify` for visual confirmation after significant UI changes, and `/code-review` before finalizing large changes.

## App architecture

Use a simple modular SwiftUI architecture suitable for prototyping:

```text
App/
  PrototypeApp.swift
  RootView.swift
  AppRouter.swift

Shared/
  DesignSystem/
    AppTheme.swift
    AppSpacing.swift
    AppTypography.swift
    AppRadius.swift
    AppShadow.swift
  Components/
    AppTopBar.swift
    SearchPill.swift
    ServiceTile.swift
    BannerView.swift
    BannerSlot.swift
    BottomSheetCard.swift
    MapPlaceholderView.swift
    PriceRow.swift
    RatingBadge.swift
    EmptyStateView.swift
  Models/
    AppFeature.swift
    Banner.swift
    BannerPlacement.swift
    CustomScreen.swift
    MockUser.swift
  Data/
    MockContentStore.swift
    MockRideData.swift
    MockFoodData.swift
    MockActivityData.swift
  Utilities/
    Haptics.swift
    PreviewFixtures.swift

Features/
  Home/
    HomeDashboardView.swift
    HomeViewModel.swift
  Ride/
    RideHomeView.swift
    RideSearchView.swift
    RideMapView.swift
    RideOptionsSheet.swift
    RideConfirmView.swift
    RideStatusView.swift
  Food/
    FoodHomeView.swift
    RestaurantListView.swift
    RestaurantDetailView.swift
    CartView.swift
    MockCheckoutView.swift
  Grocery/
    GroceryHomeView.swift
  Courier/
    CourierHomeView.swift
  Activity/
    ActivityView.swift
    ActivityDetailView.swift
  Account/
    AccountView.swift
    MockProfileView.swift
  PrototypeLab/
    PrototypeLabView.swift
    BannerEditorView.swift
    CustomScreenEditorView.swift
    CustomScreenRendererView.swift
```

If the existing project already has a different structure, adapt without creating unnecessary churn.

## Navigation model

Use `NavigationStack` and a small router where useful. Keep flows shallow and prototype-friendly.

Root navigation:

- Home
- Activity
- Account
- Prototype Lab, visible only in debug builds or behind a visible "Prototype Tools" entry in Account

Home services:

- Taxi
- Food
- Grocery
- Courier
- Reserve
- Saved places

Ride flow:

1. HomeDashboardView
2. RideSearchView: pickup and destination search with mock suggestions
3. RideMapView: static map/mock map with route line placeholder and bottom sheet
4. RideOptionsSheet: selectable ride options and prices
5. RideConfirmView: mock payment, pickup, promo banner slot
6. RideStatusView: mock driver arriving state

Food flow:

1. FoodHomeView: cuisine chips, hero banner, restaurant cards
2. RestaurantListView: filters and list cards
3. RestaurantDetailView: menu sections and item cards
4. CartView: quantity controls and mock totals
5. MockCheckoutView: fake delivery address and place-order button

Activity flow:

- Segmented control for rides and orders.
- Cards with date, route/store, price, status.
- Detail screen with timeline rows.

Account flow:

- Mock user card.
- Saved places.
- Payment methods mocked.
- Settings mocked.
- Prototype Tools entry.

## Visual design direction

Create an original design system inspired by common ride-hailing and delivery UX patterns.

Core look:

- Minimal, premium, utility-first.
- Strong black/white contrast with a small accent color.
- Rounded cards and pill controls.
- Dense but readable cards.
- Large bottom sheets over map or content.
- Clean SF Symbol icons.
- No copied brand assets.

Suggested tokens:

```swift
enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum AppRadius {
    static let sm: CGFloat = 10
    static let md: CGFloat = 16
    static let lg: CGFloat = 22
    static let pill: CGFloat = 999
}
```

Use semantic colors, not hard-coded random values scattered through views:

- `surfacePrimary`
- `surfaceSecondary`
- `textPrimary`
- `textSecondary`
- `accentPrimary`
- `success`
- `warning`
- `divider`

Prefer adaptive system colors where possible so dark mode is easy to support.

## Common UI components

Build these reusable components early:

### SearchPill

A large rounded search control used on Home and Ride screens.

Requirements:

- Icon on left.
- Placeholder or selected destination.
- Optional trailing action.
- Height around 52-60 points.
- Accessibility label.

### ServiceTile

A compact card for Taxi, Food, Grocery, Courier, Reserve, and other services.

Requirements:

- SF Symbol icon.
- Title.
- Optional badge such as "New" or "Promo".
- Works in a grid.
- Tap target at least 44x44 points.

### BannerSlot and BannerView

Data-driven banner renderer. Every main screen should be able to render zero or more banners by placement.

Banner types:

- `hero`: large promo at top of a screen.
- `compact`: small inline promo.
- `warning`: operational message.
- `reward`: loyalty or discount message.
- `experiment`: product test banner.

Banner placements:

- `homeTop`
- `homeFeed`
- `rideSearchTop`
- `rideOptionsTop`
- `rideConfirmTop`
- `foodHomeTop`
- `restaurantListTop`
- `cartTop`
- `activityTop`
- `accountTop`
- `customScreenTop`

Banners must be local data and easy to edit from `MockContentStore` or Prototype Lab.

### BottomSheetCard

A reusable container for ride options, checkout summaries, and route details.

Requirements:

- Rounded top corners.
- Drag indicator visual if used as a sheet.
- Clear section title.
- Safe-area aware.
- Works inside `.sheet`, `.presentationDetents`, or as a pinned overlay.

### MapPlaceholderView

For prototype mode, use a stylized mock map or MapKit with fixed coordinates. Do not request live location unless the user explicitly asks.

Requirements:

- Route line visual or placeholder.
- Pickup/dropoff pins.
- Light visual noise to imply a map.
- Overlay-safe for bottom sheets.

## Data model guidance

Keep data simple and editable.

Example models:

```swift
struct Banner: Identifiable, Codable, Equatable {
    let id: UUID
    var placement: BannerPlacement
    var title: String
    var message: String
    var callToAction: String?
    var style: BannerStyle
    var isEnabled: Bool
}

enum BannerPlacement: String, Codable, CaseIterable, Identifiable {
    case homeTop
    case homeFeed
    case rideSearchTop
    case rideOptionsTop
    case rideConfirmTop
    case foodHomeTop
    case restaurantListTop
    case cartTop
    case activityTop
    case accountTop
    case customScreenTop

    var id: String { rawValue }
}

enum AppFeature: String, Codable, CaseIterable, Identifiable {
    case taxi
    case food
    case grocery
    case courier
    case reserve
    case prototypeLab

    var id: String { rawValue }
}
```

For the first version, keep mock content in Swift fixtures. If the Product Owner needs runtime editing, use `UserDefaults` for simple JSON persistence or SwiftData if the prototype needs structured persistence.

## Prototype Lab requirements

Prototype Lab exists so the Product Owner can quickly test banners and simple screens without full engineering work.

Minimum functionality:

1. View all banner placements.
2. Enable or disable each banner.
3. Edit banner title, message, call-to-action, style, and placement.
4. Preview how a banner looks.
5. Create a simple custom screen with:
   - title
   - subtitle
   - optional top banner
   - list of content cards
   - primary action button
6. Open custom screens from Prototype Lab and optionally from Home.

Keep Prototype Lab clearly marked as internal prototype tooling.

## Content style

Use concise, neutral, generic copy.

Good examples:

- "Where to?"
- "Book a taxi"
- "Food near you"
- "Arrives in 5 min"
- "Save 20% on lunch"
- "Try Priority pickup"
- "Send a package"
- "Continue as Demo User"

Avoid:

- Real Uber product names.
- Claims that imply real service availability.
- Real prices that could be interpreted as operational.
- Real driver, restaurant, or courier identities unless clearly fake.

Use mock names:

- Driver: Alex Morgan, Sam Lee, Taylor Kim.
- Restaurants: Green Bowl, City Pizza, Noodle House, Sunrise Cafe.
- Locations: Central Station, City Park, Market Street, Office Tower.

## Feature flags

Use a small local feature flag system for experiments:

```swift
struct FeatureFlags: Codable, Equatable {
    var isFoodEnabled = true
    var isGroceryEnabled = true
    var isCourierEnabled = true
    var isPrototypeLabEnabled = true
    var isPriorityPickupEnabled = false
    var isNewBannerSystemEnabled = true
}
```

Expose feature flags in Prototype Lab where practical.

## Accessibility requirements

- Every button and tappable row needs a useful accessibility label.
- Do not rely only on color to communicate status.
- Support Dynamic Type for text-heavy screens.
- Ensure touch targets are at least 44x44 points.
- Avoid tiny low-contrast secondary text.
- Use `accessibilityElement(children: .combine)` for dense cards when it improves VoiceOver.
- Add preview variants for light mode, dark mode, and larger text where practical.

Use accessibility skills for any non-trivial screen or component.

## Testing guidance

Use tests for logic, not for every prototype visual detail.

Good test targets:

- Banner filtering by placement and enabled state.
- Feature flag defaults.
- Mock price calculation.
- Cart total calculation.
- Custom screen encoding/decoding.
- View model state transitions.

Use Swift Testing if the project supports it; otherwise use XCTest.

## Performance guidance

- Keep views decomposed when a SwiftUI body becomes hard to scan.
- Use `LazyVStack` or `LazyVGrid` for scrollable lists.
- Do not overuse animations.
- Avoid large inline mock arrays inside view bodies.
- Keep image use lightweight; prefer SF Symbols and simple shapes.
- Use the SwiftUI Performance Audit skill if a screen becomes complex.

## Implementation preferences

- Prefer `struct` models and immutable fixtures.
- Use `@Observable` or `ObservableObject` depending on project target and style.
- Use `@State` for local UI state.
- Use `@StateObject` / `@ObservedObject` only where needed in older codebases.
- Keep business logic out of SwiftUI view bodies.
- Use dependency injection for mock stores when it keeps previews and tests simple.
- Avoid overengineering with coordinators, dependency containers, or networking layers unless requested.
- Prefer readable code over clever abstractions.

## Expected first milestone

When asked to create the initial prototype, build this milestone first:

1. App opens directly to Home.
2. Home has:
   - top greeting for Demo User
   - large "Where to?" search pill
   - service tile grid for Taxi, Food, Grocery, Courier
   - top banner slot
   - recent activity cards
3. Taxi flow has:
   - destination search
   - mock map screen
   - ride option bottom sheet
   - confirm ride screen
4. Food flow has:
   - restaurant list
   - restaurant detail
   - cart/checkout mock
5. Activity screen has mock ride and food order history.
6. Account screen has mock profile and Prototype Tools entry.
7. Prototype Lab can enable/disable and edit at least one banner per major screen.
8. Build succeeds on an iOS Simulator.

## Acceptance criteria for UI work

A UI task is done when:

- The app builds.
- The screen is reachable from navigation.
- The screen has realistic mock data.
- The visual style matches the project design direction.
- The screen has at least one preview when practical.
- Tappable elements are accessible.
- Banner slots are included where the screen supports promotions or product tests.
- The result avoids copied Uber branding or exact trade dress.

## How to respond after changes

After implementation, report:

- Files created or modified.
- Main behavior added.
- Relevant skills used.
- Build/test command run and result.
- Manual steps for the Product Owner to verify the feature in the app.

Keep the response practical and focused on what changed.

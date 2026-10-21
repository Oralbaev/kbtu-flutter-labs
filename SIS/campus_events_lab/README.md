# Campus Events — Flutter Lab 01

Offline campus-events manager with 3 tabs (Events, Favourites, Profile), a details screen and a create/edit form. All data is in memory.

## Run

```bash
flutter create --platforms=android,ios,web .
flutter pub get
flutter run
flutter analyze
dart format .
```

## Screenshots

After running, save three real screenshots here:
- `screenshots/phone_light.png`
- `screenshots/phone_dark.png`
- `screenshots/tablet_grid.png`

## Decisions

The event list and profile live in HomeShell state, so all tabs read the same data. Detail receives callbacks so it can change data without owning the source of truth. The form returns an Event through Navigator.pop, letting the caller commit only after a successful save. LayoutBuilder decides between list and grid based on actual available width, not device identity. The form compares a snapshot of current values with the values on opening to detect dirty edits. PopScope intercepts unsaved exits and prompts for confirmation. Derived counts are computed directly from the immutable event record rather than separately stored. With a later state-management lesson, I would move event and profile storage into a dedicated repository and notifier.

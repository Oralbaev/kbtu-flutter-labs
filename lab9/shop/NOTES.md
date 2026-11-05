# Practice 9 — Put It High, Subscribe Low

## Level 1 — Lift State Up

### State Management

- Cart was stored in Shell using StatefulWidget.
- Shell managed the cart using setState().
- BooksScreen received cart and onAdd.
- CartScreen received items and onRemove.
- CartBadge received count.
- State was passed down through parameters, and callbacks were passed up.

### Passing Total Down

Modified 2 constructors:

1. BooksScreen — added total.
2. CartBadge — added total.

Files changed:
- lib/main.dart
- lib/books_screen.dart
- lib/cart_badge.dart

This demonstrated prop drilling because intermediate widgets passed data they did not use.

### Rebuild Measurement

Action: Press Add once.

BooksScreen builds: [measured count]

Book row builds: [measured count]

Total debug messages: [measured count]

One full BooksScreen build produces 1 screen message and 6 row messages.

---

## Level 2 — A Model With No Widgets

### Cart Model

- Moved Book and books to models/book.dart.
- Created Cart extends ChangeNotifier.
- Used a private List<Book> _items.
- Added getters: items, count, total.
- Added methods: add, remove, clear.
- Used notifyListeners() after mutations.
- Prevented duplicate books inside add().

### Encapsulation

List.unmodifiable() prevents external code from modifying the cart directly.

### Independent Test

Added two books, tried adding a duplicate, and removed one.

Expected output:

```text
1 items, 3100 ₸
```

### Unmodifiable List Test

Trying to modify cart.items directly produces:

```text
Unsupported operation: Cannot add to an unmodifiable list
```

### Separation of Logic

Cart contains no BuildContext, SnackBar, Navigator, or UI widgets.

---

## Level 3 — The Same App With Provider

### Provider Integration

- Installed provider.
- Added ChangeNotifierProvider above MaterialApp.
- Shell became StatelessWidget.
- Removed cart parameters and callbacks from widget constructors.
- BooksScreen used context.watch and context.read.
- CartBadge used context.watch.
- CartScreen used Consumer<Cart>.

### Experiment 1 — watch Inside Callback

Changed context.read<Cart>() to context.watch<Cart>() inside onPressed.

Observed error:

[Paste exact Provider error message]

Reason:
watch cannot establish a listening dependency from an event callback.

### Experiment 2 — read Instead of watch

Changed context.watch<Cart>() to context.read<Cart>() in CartBadge.

Observed result:

[Write the actual badge behavior]

Reason:
read does not subscribe to Cart changes, so the badge may show outdated data.

---

## Level 4 — Scope and Rebuilds

### Cart Quantities

- Replaced List<Book> with Map<Book, int>.
- count returns the number of distinct books.
- qtyOf returns the quantity of a book.
- increment increases quantity.
- total includes quantity multiplied by price.

### watch vs select

Action: Press + three times on a cart item.

With context.watch:
Badge rebuilds: [measured count]

With context.select:
Badge rebuilds: [measured count]

Expected subscription-triggered rebuilds:
- watch: 3
- select: 0

### Explanation

context.watch subscribes to all Cart notifications.

context.select subscribes to a selected value.
If count stays unchanged, a quantity update does not require a badge rebuild.

### Consumer child

The static Total label and icon are passed through the Consumer child parameter.

This allows Flutter to reuse the unchanged widget instead of recreating it on each Cart notification.

### Subscription Scope

Adding context.watch<Cart>() to BooksScreen.build caused unnecessary screen and row rebuilds.

Moving subscriptions closer to the widgets that need the values reduces unnecessary work.

---

## Level 5 — Logic on the Right Side

### SnackBar

- Cart.add() returns bool.
- The widget checks the returned value.
- SnackBar shows "Added" only when add() returns true.
- Cart does not contain UI logic.

### Clear Cart

- Added Clear cart to CartScreen AppBar.
- Used showDialog<bool> with AlertDialog.
- Cancel keeps the cart unchanged.
- Clear calls context.read<Cart>().clear().
- Used context.mounted after await.

### Search

- Added a search field to BooksScreen.
- Search text is stored in local widget state.
- Books are filtered by title, case-insensitively.

### Where Does It Live?

1. Cart — Provided. Shared between multiple screens.
2. Search text — Ephemeral. Only BooksScreen needs it.
3. Total expanded/collapsed — Ephemeral. Only CartScreen needs it.
4. Theme mode — Lifted. Affects the whole application.

---

## Final Verification

- Cart uses ChangeNotifier and a private Map.
- ChangeNotifierProvider is above MaterialApp.
- No cart parameters are passed through constructors.
- watch is used during build.
- read is used inside callbacks.
- CartBadge uses context.select.
- CartScreen uses Consumer with a const child.
- Models contain no UI logic.
- The Added SnackBar and Clear dialog work.
- NOTES.md contains all required experiments.
- Level 1 is saved in Git history with commit "lifted".
- dart format . completed.
- flutter analyze: [Paste actual result]
- screenshot_books.png and screenshot_cart.png are committed.
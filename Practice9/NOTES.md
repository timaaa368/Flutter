
# Practice 9 - Put It High, Subscribe Low

## Level 1 - Lift it up

Constructors changed: 3

Files changed:
- main.dart
- books_screen.dart
- cart_badge.dart
- cart_screen.dart

The cart was stored in Shell.
Data was passed down through constructors.
Callbacks were passed up to the owner.

## Level 2 - Model

Cart extends ChangeNotifier.
The cart uses a private Map.
Duplicate books are not allowed.
List.unmodifiable protects the cart.

## Level 3 - Provider

Used ChangeNotifierProvider.
Used context.watch, context.read and Consumer.

Watch error:
Tried to listen to a value exposed with provider from outside of the widget tree.

Read problem:
The badge stayed at 0 because read does not subscribe to changes.

## Level 4 - Scope

The badge uses context.select<Cart, int>.
The badge rebuilds only when count changes.

Watch rebuild count: 3
Select rebuild count: 0

## Level 5 - Where does it live?

1. Cart - provided. Both screens need access to it.
2. Search text - ephemeral. Only BooksScreen needs it.
3. Total expanded/collapsed - ephemeral. Only CartScreen needs it.
4. Theme mode - lifted. Multiple screens need the same theme.

SnackBar and Dialog are handled in widgets.
Cart model contains no BuildContext or UI logic.

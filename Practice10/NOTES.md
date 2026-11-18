
# Practice 10 - The Data Arrives Later

## Level 1 - Fake API

Predicted order:
A, C, B, 6 students

Actual order:
A, C, B, 6 students

fetchStudents waits 2 seconds.
Every third request fails with NoConnectionException.

## Level 2 - Four states

- Loading
- Error
- Empty
- Data

Error:
setState() called after dispose()

The mounted check prevents this error.

## Level 3 - FutureBuilder

Future is stored in a field.
Switch does not reload students.
Retry creates a new Future.

## Level 4 - Countdown

Version A:
StreamBuilder manages its subscription.
Leaving the screen stops the stream.

Version B:
StreamSubscription is cancelled in dispose().
Without cancel(), ticks continue after leaving.

## Level 5 - Save

Unhandled Exception: Bad state: server rejected 6

The first Save succeeds.
The second Save fails.

The Future is awaited.
StateError is caught.
context.mounted is checked after await.
The button is disabled while saving.

## Conclusion

Future, async, await, FutureBuilder,
StreamBuilder, mounted and cancel()
were practiced.

import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';

/// Manages the undo/redo stacks and command execution.
///
/// The CommandProcessor is responsible for:
/// - Executing commands and tracking them in the undo stack
/// - Managing the undo/redo operations
/// - Enforcing the undo stack limit (100 commands)
/// - Clearing the redo stack when new commands are executed
class CommandProcessor {
  /// Maximum number of commands to keep in the undo stack.
  static const int maxUndoStackSize = 100;

  final List<Command> _undoStack = [];
  final List<Command> _redoStack = [];

  /// Whether there are commands available to undo.
  bool get canUndo => _undoStack.isNotEmpty;

  /// Whether there are commands available to redo.
  bool get canRedo => _redoStack.isNotEmpty;

  /// The number of commands in the undo stack.
  int get undoStackSize => _undoStack.length;

  /// Description of the command that would be undone.
  /// Returns null if undo stack is empty.
  String? get undoDescription =>
      _undoStack.isNotEmpty ? _undoStack.last.description : null;

  /// Description of the command that would be redone.
  /// Returns null if redo stack is empty.
  String? get redoDescription =>
      _redoStack.isNotEmpty ? _redoStack.last.description : null;

  /// Executes a command and adds it to the undo stack.
  ///
  /// This clears the redo stack (new actions invalidate redo history).
  /// If the undo stack exceeds the limit, the oldest command is discarded.
  ProjectState execute(Command command, ProjectState state) {
    final newState = command.execute(state);

    _undoStack.add(command);
    _redoStack.clear();

    // Enforce stack limit
    while (_undoStack.length > maxUndoStackSize) {
      _undoStack.removeAt(0);
    }

    return newState;
  }

  /// Undoes the last command and moves it to the redo stack.
  ///
  /// Returns the state before the last command was executed.
  /// If undo stack is empty, returns the state unchanged.
  ProjectState undo(ProjectState state) {
    if (!canUndo) return state;

    final command = _undoStack.removeLast();
    _redoStack.add(command);

    return command.undo(state);
  }

  /// Redoes the last undone command and moves it back to the undo stack.
  ///
  /// Returns the state after re-executing the command.
  /// If redo stack is empty, returns the state unchanged.
  ProjectState redo(ProjectState state) {
    if (!canRedo) return state;

    final command = _redoStack.removeLast();
    _undoStack.add(command);

    return command.execute(state);
  }

  /// Clears both undo and redo stacks.
  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}

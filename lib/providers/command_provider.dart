import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/commands/command_processor.dart';
import 'package:flutter_forge/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'command_provider.freezed.dart';

/// State for the command provider (undo/redo status).
@freezed
class CommandState with _$CommandState {
  const factory CommandState({
    @Default(false) bool canUndo,
    @Default(false) bool canRedo,
    String? undoDescription,
    String? redoDescription,
  }) = _CommandState;
}

/// Provides command execution with undo/redo support.
///
/// This provider integrates with [projectProvider] to:
/// - Execute commands that modify project state
/// - Track command history for undo/redo
/// - Notify listeners when undo/redo availability changes
final commandProvider =
    StateNotifierProvider<CommandNotifier, CommandState>((ref) {
  return CommandNotifier(ref);
});

/// State notifier for command execution and undo/redo.
class CommandNotifier extends StateNotifier<CommandState> {
  CommandNotifier(this._ref) : super(const CommandState());

  final Ref _ref;
  final CommandProcessor _processor = CommandProcessor();

  /// Whether there are commands available to undo.
  bool get canUndo => _processor.canUndo;

  /// Whether there are commands available to redo.
  bool get canRedo => _processor.canRedo;

  /// Description of the command that would be undone.
  String? get undoDescription => _processor.undoDescription;

  /// Description of the command that would be redone.
  String? get redoDescription => _processor.redoDescription;

  /// Executes a command and updates the project state.
  ///
  /// The command is added to the undo stack and the redo stack is cleared.
  void execute(Command command) {
    final projectNotifier = _ref.read(projectProvider.notifier);
    final currentState = _ref.read(projectProvider);

    final newState = _processor.execute(command, currentState);
    projectNotifier.setState(newState);

    _updateState();
  }

  /// Undoes the last command.
  ///
  /// Moves the command to the redo stack.
  void undo() {
    if (!canUndo) return;

    final projectNotifier = _ref.read(projectProvider.notifier);
    final currentState = _ref.read(projectProvider);

    final newState = _processor.undo(currentState);
    projectNotifier.setState(newState);

    _updateState();
  }

  /// Redoes the last undone command.
  ///
  /// Moves the command back to the undo stack.
  void redo() {
    if (!canRedo) return;

    final projectNotifier = _ref.read(projectProvider.notifier);
    final currentState = _ref.read(projectProvider);

    final newState = _processor.redo(currentState);
    projectNotifier.setState(newState);

    _updateState();
  }

  /// Clears the command history.
  void clear() {
    _processor.clear();
    _updateState();
  }

  /// Updates the provider state based on processor state.
  void _updateState() {
    state = CommandState(
      canUndo: _processor.canUndo,
      canRedo: _processor.canRedo,
      undoDescription: _processor.undoDescription,
      redoDescription: _processor.redoDescription,
    );
  }
}

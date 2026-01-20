import 'package:flutter_forge/core/models/project_state.dart';

/// Abstract base class for all editor commands.
///
/// Commands encapsulate operations that can be executed and undone,
/// enabling the undo/redo system. All state-changing operations
/// should be implemented as commands.
abstract class Command {
  /// Human-readable description for menu labels.
  /// Used in "Undo: [description]" and "Redo: [description]".
  String get description;

  /// Executes this command against the given state.
  ///
  /// Returns the new state after the command has been applied.
  /// Commands should not modify the input state directly;
  /// instead they should return a new state using copyWith.
  ProjectState execute(ProjectState state);

  /// Undoes this command, reverting to the previous state.
  ///
  /// Returns the state as it was before this command was executed.
  ProjectState undo(ProjectState state);

  /// Serializes this command to JSON for persistence.
  ///
  /// This enables saving undo history with project files.
  Map<String, dynamic> toJson();
}

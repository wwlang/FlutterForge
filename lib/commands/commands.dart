/// Command pattern implementation for undo/redo support.
///
/// This library provides the core command infrastructure:
/// - `Command` - Abstract base class for all commands
/// - `CommandProcessor` - Manages undo/redo stacks
/// - Concrete commands for widget operations
library;

export 'add_widget_command.dart';
export 'command.dart';
export 'command_processor.dart';
export 'delete_widget_command.dart';
export 'move_widget_command.dart';
export 'property_change_command.dart';
export 'wrap_widget_command.dart';

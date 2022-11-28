// ignore_for_file: curly_braces_in_flow_control_structures

class UndoRedo {
  String? undo({
    required List<String> undoStack,
    required List<String> redoStack,
    required String text,
  }) {
    if (undoStack.isEmpty) return null;
    String? word = getLastWord(text);
    redoStack.add(word.toString());
    undoStack.removeLast();
    int last = text.length - word!.length;
    return text.substring(0, last - 1);
  }

  String? redo({required List redoStack, required List<String> undoStack}) {
    if (redoStack.isEmpty) return null;
    undoStack.add(redoStack.last);
    return " ${redoStack.removeLast()}";
  }

  String addToUndoStack({
    required String letter,
    required String counter,
    required List undoStack,
  }) {
    if (letter == " ") {
      undoStack.add(counter.substring(0, counter.length - 1));
      return "";
    } else {
      counter += letter;
    }
    return counter;
  }

  void onBackspace() {}

  String? getLastWord(String word) {
    int length = word.length;
    if (word[length - 1] == " ") return null;
    for (int i = length - 1; i >= 0; i--) {
      if (word[i] == " ") {
        return word.substring(i + 1, length);
      }
    }
    return word.substring(0, length);
  }
}

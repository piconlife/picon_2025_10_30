enum ContentUiState { none, processing, processed }

extension ContentStateHelper on ContentUiState {
  bool get isNone => this == ContentUiState.none;

  bool get isProcessing => this == ContentUiState.processing;

  bool get isProcessed => this == ContentUiState.processing;
}

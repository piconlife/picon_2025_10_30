class CacheConfig {
  final int maxSize;

  final Duration? defaultTtl;

  final bool deduplicateInFlight;

  const CacheConfig({
    this.maxSize = 128,
    this.defaultTtl,
    this.deduplicateInFlight = true,
  }) : assert(maxSize > 0, 'maxSize must be positive');
}

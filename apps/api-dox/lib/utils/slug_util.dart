class SlugUtil {
  static String slugify(String name) {
    String slug = name
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug.length > 64 ? slug.substring(0, 64) : slug;
  }
}

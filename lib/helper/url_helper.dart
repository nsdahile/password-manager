class UrlHellper {
  static String correctUrl(String url) {
    if (!url.startsWith('http')) {
      url = 'https://' + url;
    }
    return url;
  }
}

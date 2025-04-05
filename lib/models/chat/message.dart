class Message {
  const Message({required this.text, this.isResponse = false});

  final String text;
  final bool isResponse;
}

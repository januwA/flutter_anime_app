import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;

dom.Element $(parent, String select) {
  return parent.querySelector(select);
}

List<dom.Element> $$(parent, String select) {
  return parent.querySelectorAll(select);
}

Future<dom.Document> $document(String url) async {
  var r = await http.get(url);
  dom.Document document = html.parse(r.body);
  return document;
}

import 'dart:html' as dart_html;
import 'dart:convert';
import '../lib/contacts.dart';
import 'package:dart_web_toolkit/ui.dart' as ui;
import 'package:dart_web_toolkit/event.dart' as event;

void load() {
  String json = dart_html.window.localStorage['history'];
  if (json == null) {
    Model.one.init();
  } else {
    Model.one.fromJson(JSON.decode(json));
  }
}

save() {
  dart_html.window.localStorage['history'] = JSON.encode(Model.one.toJson());
}

void main() {
  load();
  //dart_html.window.localStorage.clear();
  Links links = new Links();
  for (Contact contact in Model.one.contacts.internalList) {
    links.add(new ui.Hyperlink("${contact.name}", false, "${contact.name}"));
  }

  ui.Label lbl = new ui.Label();
  ui.Label lb = new ui.Label();
  ui.Label lbl0 = new ui.Label('Name:');
  ui.Label lbl1 = new ui.Label('Phone:');
  ui.Label lbl2 = new ui.Label('E-mail:');
  ui.TextBox box0 = new ui.TextBox();
  ui.TextBox box1 = new ui.TextBox();
  ui.TextBox box2 = new ui.TextBox();
  ui.Button addButton = new ui.Button();
  ui.Button clearButton = new ui.Button();
  
  addButton.html = '''<button id='aB'>Add</button>''';
  clearButton.html = '''<button id='cB'>Clear</button''';
  
  ui.HorizontalPanel panel0 = new ui.HorizontalPanel();
  panel0.spacing = 10;
  ui.HorizontalPanel panel1 = new ui.HorizontalPanel();
  panel1.spacing = 8;
  ui.HorizontalPanel panel2 = new ui.HorizontalPanel();
  panel2.spacing = 8;
  ui.HorizontalPanel panel3 = new ui.HorizontalPanel();
  panel3.spacing = 10;
  ui.VerticalPanel panel4 = new ui.VerticalPanel();

  panel0..add(lbl0)..add(box0);
  panel1..add(lbl1)..add(box1);
  panel2..add(lbl2)..add(box2);
  panel3..add(addButton)..add(clearButton);
  
  for (Contact contact in Model.one.contacts) {
    panel4.add(new ui.Hyperlink("${contact.name}", false, "${contact.name}"));
  }

  ui.History.addValueChangeHandler(new event.ValueChangeHandlerAdapter((event.ValueChangeEvent<String> evt){
    box0.text = "${evt.value}";
    if (evt.value == '') {
      box1.text = "";
      box2.text = "";
    } else {
    Contact cibleContact = Model.one.contacts.find(evt.value);
    ui.Hyperlink cibleLink = links.find(evt.value);
    box1.text = "${cibleContact.phone}";
    box2.text = "${cibleContact.e_mail}";
    Model.one.contacts.remove(cibleContact);
    links.remove(cibleLink);
    panel4.remove(cibleLink);
    save();
    }
  }));
  
  addButton.addClickHandler(new event.ClickHandlerAdapter((event.ClickEvent evt){
    String userName = box0.text;
    if (userName == '') {
      ui.PopupPanel popup = new ui.PopupPanel(true);
      ui.Label msg = new ui.Label('There is no contact to add.');
      popup.setGlassEnabled(true);
      popup.setAnimationEnabled(true);
      popup.getContainerElement().style.fontSize = '25px';
      popup.add(msg);
      popup.center();
      popup.show();
  } else {
    String userPhone = box1.text;
    String userEmail = box2.text;
    Contact cibleContact1 = new Contact(userName, userPhone, userEmail);
    ui.Hyperlink cibleLink1 = new ui.Hyperlink("${cibleContact1.name}", false, "${cibleContact1.name}");
    Model.one.contacts.add(cibleContact1);
    links.add(cibleLink1);
    panel4.add(cibleLink1);
    box0.text = '';
    box1.text = '';
    box2.text ='';
    save();
    
  }
  }));
  
  clearButton.addClickHandler(new event.ClickHandlerAdapter((event.ClickEvent evt){
    if (box0.text == '') {
      ui.PopupPanel popup1 = new ui.PopupPanel(true);
      ui.Label msg = new ui.Label('There is no contact info to clear.');
      popup1.setGlassEnabled(true);
      popup1.setAnimationEnabled(true);
      popup1.getContainerElement().style.fontSize = '25px';
      popup1.add(msg);
      popup1.center();
      popup1.show();
  } else {
    box0.text = '';
    box1.text = '';
    box2.text ='';
  }
  }));

  ui.History.fireCurrentHistoryState();

  ui.RootPanel.get('container0')..add(panel0)..add(panel1)..add(panel2)..add(panel3);
  ui.RootPanel.get('container1').add(panel4);
}
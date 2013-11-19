  import 'dart:html';
  import 'dart:async';
  import 'dart:isolate';
  import 'dart:convert';
  import 'dart:mirrors';
  import 'package:js/js.dart' as js;
  import 'package:json/json.dart' as json;


  String tmpS;

  dynamic CreateInstance(Symbol packagename,Symbol classname)
  {
    MirrorSystem mirrors = currentMirrorSystem();
    dynamic lf = mirrors.findLibrary(packagename);
    var lm=(lf.first as LibraryMirror);
    ClassMirror cm = lm.classes[classname];
    InstanceMirror im = cm.newInstance(const Symbol(''), []);
    return im.reflectee;
  }

  class ca
  {
    String s;
    void pp(String n)
    {
      print(s+n);
    }
  }

  class cb
  {
    String s;
    ca a;
  }

  class jsontest
  {
    String s;
    cb b;
  }


  Future func1(jsontest jt)
  {
    print('enter func1');
    var completer=new Completer();
    //while(true); // change to isolate for testing
  var receivePort= new ReceivePort();
  receivePort.receive((msg,_)
         {
            if (msg=='close')
              {
                completer.complete(msg);
                print('session done');
                receivePort.close();
              }
            else {
              print(msg);
            }
         });
  var sendPort=spawnFunction(func2,(e){
     if (e!=null) print(e.toString());

  });
  print('sending start');
  sendPort.send('start', receivePort.toSendPort());
  print('sending object');
  sendPort.send(jt, receivePort.toSendPort());
  print('sending stop');
  sendPort.send('stop', receivePort.toSendPort());
    return completer.future;
  }

  func2()
  {

    //print('enter func2');

  port.receive((msg,replyTo){
   // print('receive msg:[$msg]');
    if (msg is jsontest)
    {
      msg=(msg as jsontest).s+(msg as jsontest).b.s+(msg as jsontest).b.a.s;
    }
    replyTo.send('receive msg [$msg]');
    switch(msg)
    {
      case 'start':

        break;
      case 'stop':
        replyTo.send('close');
        port.close();
        break;
      default:
        break;
    };
  });
  }

  class zzz
  {
    zzz z;
    String s='123';
    Map m={};
    List l=[];
  }

  void main() {
    var element=query("#sample_text_id");
  var title=query("#title_id");

  var aa=new ca()..s='1';
  var bb=new cb()..a=aa..s='2';
  var cc=new jsontest()..b=bb..s='3';

  var hh=reflect(aa);
  hh.invoke('pp', ['-----']);

  var ee=CreateInstance(const Symbol('dart.core'),const Symbol('StringBuffer'));



  var btn=new ButtonElement()
     ..text="test"
     ..id="btn_id"
     ..onClick.listen((Event e)
      {
          var dd=JSON.encode(cc);
          element.text=dd;
          assert(()=>true);
      }
  )
  ;


  var f=func1(cc)
      ..then((onValue){
          var zz1=new zzz()
                  ..s="zz1"
                  ..l=["zz11","zz12"]
                  ..m={'a':"zz1a",'b':"zz1b"}
                  ..z=new zzz()
                    ..s="zz2"
                    ..l=["zz21","zz22"]
                    ..m={'a':"zz2a",'b':"zz2b"};
          var zz=json.stringify(zz1.l);

          var ss='hello';
          js.scoped((){
            js.context.sss=ss;
            js.context.zz1=js.map({'s':'zz1','l':['zz11','zz12'],'m':{'a':'zz1a','b':'zz1b'}});
            var rr=js.context.eval('''(function(){
                                          zz1['g']='new string';
                                          //alert(zz1['m']['a']); 
                                          return zz1;
                                        }())''');

            print(rr['g']);
          });
          js.release(js.context);
          var qq=js.context.eval('''(function(){    
              //alert(zz1['m']['a']); 
              return zz1;
          }())''');
          print(qq['g']);
          print(js.context.sss);
      });

  var container=element.parent;
  container.children.add(btn);

  query("#sample_text_id")
    ..text = "Click me!"
      ..onClick.listen(reverseText)
      ..onMouseEnter.listen((MouseEvent e)
          {
            tmpS=element.text;
            element.text=title.text;
          }
      )
      ..onMouseLeave.listen((MouseEvent e)
          {
            element.text=tmpS;
          }
      );
  }

  void reverseText(MouseEvent event) {
    var text = query("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  query("#sample_text_id").text = buffer.toString();
  }

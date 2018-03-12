import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());
var gastos = [];
var _cantidad = [];
var loaded = false;
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Mis gastos',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new LoadScreen(),
      routes: <String, WidgetBuilder> { 
        '/loader': (BuildContext context) => new LoadScreen(), 
        '/home' : (BuildContext context) => new MyHomeApp() 
      },
    );
  }
}

class LoadScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    loadExpenses(context);
    return new Scaffold(
      body: new Container(
        child: new Text('Holi'),
      ),
    );
  }
}

loadExpenses(BuildContext context) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(prefs.getStringList('gastos')==null&&prefs.getStringList('cantidad')==null){
    prefs.setStringList('gastos', ['Ejemplo']);
    prefs.setStringList('cantidad', ['555']);
  }
  print(prefs.getStringList('gastos'));
  gastos.addAll(prefs.getStringList('gastos'));
  _cantidad.addAll(prefs.getStringList('cantidad'));
  loaded = true;
  Navigator.of(context).pushNamedAndRemoveUntil('/home', ModalRoute.withName('/never'));
}
class MyHomeApp extends StatefulWidget{
  @override
  _MyHomeApp createState() => new _MyHomeApp();
}
class _MyHomeApp extends State<MyHomeApp> {
  final TextEditingController _textController = new TextEditingController();
  TextEditingController controller = new TextEditingController(text: "");
  void _addExpenses() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);
    if(_textController.text==""||controller.text==""){
      print('holi');
    }else{
      setState((){
        gastos.add(_textController.text);
        _cantidad.add(controller.text);
        _textController.clear();
        controller.clear();
        prefs.remove('gastos');
        prefs.remove('cantidad');
        prefs.setStringList('gastos', gastos);
        prefs.setStringList('cantidad', _cantidad);
        print(prefs.getStringList('gastos'));
      });
    }
  }
  @override
  Widget build(BuildContext context) { 
    void _addExpense(){
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (context){
            return new Scaffold(
              appBar: new AppBar(
                title: new Text('Agrega un gasto'),
              ),
              body: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      const Text('Agrega un gasto'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        leading: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Image.asset('ico/mg.png'),
        ),
        title: const Text('Mis gastos'),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new IconButton(
          icon: new Icon(Icons.add),
          color: Colors.black,
        ),
        onPressed: _showDialog,
      ),
      body:_buildRows(),
    );
  }
  Widget _buildRows (){
    return new ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, i){
        if (i.isOdd) return new Divider();
        final index = i~/2;
        return _buildRow(index);
      },
      itemCount: (gastos.length+1)*2,
    );
  }
  Widget _buildRow(final val) {
    if(val == gastos.length){
      var _prices=0;
      for(var price in _cantidad){
        try{
          _prices += int.parse(price);
        }catch(ex){
          print(ex);
        }
        
      }
      return new ListTile(
        title: const Text(
         'TOTAL',
          style: const TextStyle(
            fontSize: (20.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: new Row(
          children: <Widget>[
            new Icon(Icons.attach_money, color: Colors.green,),
            new Text(
              _prices.toString(),
              style: new TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      );
    }else{
      return new ListTile(
        leading: const Icon(Icons.monetization_on),
        title: new Text(
          gastos[val],
          style: new TextStyle(
            fontSize: (15.0),
          ),
        ),
        trailing: new Container(
          child: new Row(
            children: <Widget>[
              new Icon(Icons.attach_money, size: 17.5,),
              new Container(
                child: new Center(
                  child: new Text(_cantidad[val]),
                ),
              ),
              new Container(width: 15.0,),
              new GestureDetector(
                child: new Icon(Icons.delete, color: Colors.red,),
                onTap: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState((){
                    _cantidad.remove(_cantidad[val]);
                    gastos.remove(gastos[val]);
                    prefs.remove('gastos');
                    prefs.remove('cantidad');
                    prefs.setStringList('gastos', gastos);
                    prefs.setStringList('cantidad', _cantidad);
                    print(prefs.getStringList('gastos'));
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
  }
  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(child: new AlertDialog(
        title: new Text('Agrega un gasto'),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Inserta tu gasto'),
                    controller: _textController,
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    decoration: new InputDecoration(
                      labelText: 'Inserta la cantidad',
                    ),
                    autocorrect: false,
                    autofocus: false,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('AGREGAR'),
              onPressed: () {
                _addExpenses();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

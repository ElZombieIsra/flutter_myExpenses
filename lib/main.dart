import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Mis gastos',
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: new MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget{
  @override
  _MyHomeApp createState() => new _MyHomeApp();
}
class _MyHomeApp extends State<MyHomeApp> {
  final TextEditingController _textController = new TextEditingController();
  TextEditingController controller = new TextEditingController(text: "");
  final _gastos = ['asd','asdasddas','asdasd','wow'];
  final _cantidad = [24, 23,555,6654];
  void _click(){
    setState((){
      _gastos.add('value');
      _cantidad.add(111111);
    });
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
        title: const Text('Mis gastos'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.add),onPressed: _showDialog,),
        ],
      ),
      body: _buildRows(),
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
      itemCount: (_gastos.length+1)*2,
    );
  }
  Widget _buildRow(final val) {
    if(val == _gastos.length){
      var _prices=0;
      for(var price in _cantidad){
        _prices += price;
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
          _gastos[val],
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
                  child: new Text(_cantidad[val].toString()),
                ),
              ),
              new Container(width: 15.0,),
              new GestureDetector(
                child: new Icon(Icons.delete, color: Colors.red,),
                onTap: (){
                  setState((){
                    _cantidad.remove(_cantidad[val]);
                    _gastos.remove(_gastos[val]);
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
        contentPadding: const EdgeInsets.all(16.0),
        content: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(,
                  child: new Icon(Icons.attach_money),
                ),
                new Flexible(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Inserta tu gasto'),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Container(

                ),
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
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OPEN'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),),
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

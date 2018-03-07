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
            body: new Column(
              children: <Widget>[
                const Text('Agrega un gasto'),
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
          new IconButton(icon: new Icon(Icons.add),onPressed: _addExpense,),
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
}

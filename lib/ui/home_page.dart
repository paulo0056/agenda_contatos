import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

import 'contact_page.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contacs = List();


  @override
  void initState() {
    super.initState();

    _getAllContact();
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Contatos"),
          backgroundColor: Colors.red,
          centerTitle: true,
          actions: [
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de Z-A"),
                  value: OrderOptions.orderza,
                )
              ],
              onSelected: _orderList,
            )
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contacs.length,
            itemBuilder: (context, index){
            return _contactCard(context, index);
      },
      ),

      );
    }


    Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacs[index].img != null?
                          FileImage(File(contacs[index].img)):
                          AssetImage("images/person.png")
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contacs[index].name ?? "",
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(contacs[index].email ?? "",
                      style: TextStyle(fontSize: 18.0,),
                    ),
                    Text(contacs[index].phone ?? "",
                      style: TextStyle(fontSize: 18.0,),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
    }

    void _showOptions(BuildContext context, int index){
        showModalBottomSheet(context: context, builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          _showContactPage(contact: contacs[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          helper.deleteContact(contacs[index].id);
                         setState(() {
                           contacs.removeAt(index);
                           Navigator.pop(context);
                         });
                        },
                      ),
                    ),


                  ],
                ),
              );
            },
          );
        });
    }

    void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)));
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);

      } else {
        await helper.saveContact(recContact);

      }
      _getAllContact();
    }

    }
      void _getAllContact(){
        helper.getAllContacts().then((list){
          setState(() {
            contacs = list;
          });

        });
      }

      void _orderList(OrderOptions result){
          switch(result){
            case OrderOptions.orderaz:
              contacs.sort((a,b){
                return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              });
              break;

            case OrderOptions.orderza:
              contacs.sort((a,b){
               return b.name.toLowerCase().compareTo(a.name.toLowerCase());
              });
              break;
          }
          setState(() {

          });
      }
  }
